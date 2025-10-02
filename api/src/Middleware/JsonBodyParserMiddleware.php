<?php

namespace Chapel\Middleware;

use Chapel\Exceptions\ValidationException;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/**
 * JsonBodyParserMiddleware
 *
 * Parses JSON request bodies and attaches to request
 */
class JsonBodyParserMiddleware implements MiddlewareInterface
{
    /**
     * Process the JSON body parser middleware
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $contentType = $request->getHeaderLine('Content-Type');

        // Only parse JSON content
        if (strpos($contentType, 'application/json') !== false) {
            $body = $request->getBody()->getContents();

            if (!empty($body)) {
                $parsedBody = json_decode($body, true);

                if (json_last_error() !== JSON_ERROR_NONE) {
                    throw new ValidationException('Invalid JSON format', ['json' => ['Invalid JSON format']]);
                }

                $request = $request->withParsedBody($parsedBody);
            }
        }

        return $handler->handle($request);
    }
}
