<?php

namespace Chapel\Utils;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Exception;

/**
 * JwtHelper
 *
 * Helper class for encoding and decoding JWT tokens
 */
class JwtHelper
{
    private string $secret;
    private string $algorithm;
    private int $expiry;

    public function __construct()
    {
        $this->secret = $_ENV['JWT_SECRET'] ?? 'change-this-secret-key';
        $this->algorithm = 'HS256';
        $this->expiry = (int) ($_ENV['JWT_EXPIRY'] ?? 3600); // Default 1 hour
    }

    /**
     * Encode data into a JWT token
     *
     * @param array<string, mixed> $payload
     * @param int|null $customExpiry Custom expiry time in seconds (overrides default)
     * @return string
     */
    public function encode(array $payload, ?int $customExpiry = null): string
    {
        $expiry = $customExpiry ?? $this->expiry;

        $now = time();
        $tokenPayload = array_merge($payload, [
            'iat' => $now,
            'exp' => $now + $expiry,
            'nbf' => $now,
        ]);

        return JWT::encode($tokenPayload, $this->secret, $this->algorithm);
    }

    /**
     * Decode a JWT token
     *
     * @param string $token
     * @return array<string, mixed>
     * @throws Exception
     */
    public function decode(string $token): array
    {
        try {
            $decoded = JWT::decode($token, new Key($this->secret, $this->algorithm));

            return (array) $decoded;
        } catch (\Firebase\JWT\ExpiredException $e) {
            throw new Exception('Token has expired');
        } catch (\Firebase\JWT\SignatureInvalidException $e) {
            throw new Exception('Invalid token signature');
        } catch (\Firebase\JWT\BeforeValidException $e) {
            throw new Exception('Token not yet valid');
        } catch (Exception $e) {
            throw new Exception('Invalid token: ' . $e->getMessage());
        }
    }

    /**
     * Generate a token for a user
     *
     * @param string $userId
     * @param string $email
     * @param string $role
     * @param int|null $customExpiry
     * @return string
     */
    public function generateUserToken(string $userId, string $email, string $role, ?int $customExpiry = null): string
    {
        return $this->encode([
            'userId' => $userId,
            'email' => $email,
            'role' => $role,
        ], $customExpiry);
    }

    /**
     * Verify if a token is valid without throwing exceptions
     *
     * @param string $token
     * @return bool
     */
    public function verify(string $token): bool
    {
        try {
            $this->decode($token);

            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Get the expiry time from a token
     *
     * @param string $token
     * @return int|null Unix timestamp or null if invalid
     */
    public function getExpiry(string $token): ?int
    {
        try {
            $decoded = $this->decode($token);

            return $decoded['exp'] ?? null;
        } catch (Exception $e) {
            return null;
        }
    }

    /**
     * Check if a token is expired
     *
     * @param string $token
     * @return bool
     */
    public function isExpired(string $token): bool
    {
        $expiry = $this->getExpiry($token);

        if ($expiry === null) {
            return true;
        }

        return time() >= $expiry;
    }

    /**
     * Refresh a token (generate a new one with updated expiry)
     *
     * @param string $token
     * @param int|null $customExpiry
     * @return string
     * @throws Exception
     */
    public function refresh(string $token, ?int $customExpiry = null): string
    {
        $payload = $this->decode($token);

        // Remove standard JWT claims
        unset($payload['iat'], $payload['exp'], $payload['nbf']);

        return $this->encode($payload, $customExpiry);
    }
}
