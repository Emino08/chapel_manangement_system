<?php

namespace Chapel\Middleware;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/**
 * CorsMiddleware
 *
 * Handles CORS (Cross-Origin Resource Sharing) headers
 */
class CorsMiddleware implements MiddlewareInterface
{
    private $allowedOrigins;
    private $allowCredentials;
    private $allowedMethods;
    private $allowedHeaders;
    private $maxAge;

    public function __construct()
    {
        // Allow multiple origins for development
        $this->allowedOrigins = [
            'http://localhost:3000',
            'http://127.0.0.1:3000',
            'http://localhost:5173', // Vite dev server
            'http://127.0.0.1:5173'
        ];
        $this->allowCredentials = true;
        $this->allowedMethods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'];
        $this->allowedHeaders = [
            'Content-Type',
            'Authorization',
            'X-Requested-With',
            'Accept',
            'Origin',
            'Access-Control-Request-Method',
            'Access-Control-Request-Headers'
        ];
        $this->maxAge = 86400; // 24 hours
    }

    /**
     * Process the CORS middleware
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        // Get origin from request
        $origin = $this->getOriginFromRequest($request);

        // Handle preflight OPTIONS request (though this should be handled earlier)
        if ($request->getMethod() === 'OPTIONS') {
            $response = new \Slim\Psr7\Response();
            return $this->setCorsHeaders($response, $origin)->withStatus(200);
        }

        // Process the request
        $response = $handler->handle($request);

        // Ensure CORS headers are present (they should already be set by index.php)
        return $this->setCorsHeaders($response, $origin);
    }

    /**
     * Get origin from request headers
     */
    private function getOriginFromRequest($request)
    {
        $headers = $request->getHeaders();

        // Try different header cases
        foreach (['Origin', 'origin', 'ORIGIN'] as $header) {
            if (isset($headers[$header])) {
                if (is_array($headers[$header])) {
                    return $headers[$header][0];
                }
                return $headers[$header];
            }
        }

        return '';
    }

    /**
     * Set CORS headers on response (ensure they don't override existing headers)
     */
    private function setCorsHeaders($response, $origin)
    {
        // Only set headers if not already present
        if (!$response->hasHeader('Access-Control-Allow-Origin')) {
            $allowedOrigin = 'http://localhost:3000';
            if ($origin && in_array($origin, $this->allowedOrigins)) {
                $allowedOrigin = $origin;
            }
            $response = $response->withHeader('Access-Control-Allow-Origin', $allowedOrigin);
        }

        if (!$response->hasHeader('Access-Control-Allow-Methods')) {
            $response = $response->withHeader('Access-Control-Allow-Methods', implode(', ', $this->allowedMethods));
        }

        if (!$response->hasHeader('Access-Control-Allow-Headers')) {
            $response = $response->withHeader('Access-Control-Allow-Headers', implode(', ', $this->allowedHeaders));
        }

        if (!$response->hasHeader('Access-Control-Max-Age')) {
            $response = $response->withHeader('Access-Control-Max-Age', (string) $this->maxAge);
        }

        if ($this->allowCredentials && !$response->hasHeader('Access-Control-Allow-Credentials')) {
            $response = $response->withHeader('Access-Control-Allow-Credentials', 'true');
        }

        return $response;
    }

    /**
     * Set allowed origins
     */
    public function setAllowedOrigins($origins)
    {
        $this->allowedOrigins = is_array($origins) ? $origins : [$origins];
        return $this;
    }

    /**
     * Set allowed methods
     */
    public function setAllowedMethods($methods)
    {
        $this->allowedMethods = $methods;
        return $this;
    }

    /**
     * Set allowed headers
     */
    public function setAllowedHeaders($headers)
    {
        $this->allowedHeaders = $headers;
        return $this;
    }

    /**
     * Set credentials flag
     */
    public function setAllowCredentials($allow)
    {
        $this->allowCredentials = $allow;
        return $this;
    }
}
