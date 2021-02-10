# rubocop:disable Naming/VariableNumber

module Swagger
  module V1
    class Errors
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          error_400: {
            type: 'object',
            properties: {
              error: { type: 'string', example: 'Bad Request' }
            }
          },
          error_401: {
            type: 'object',
            properties: {
              error: { type: 'string', example: 'Unauthorized' }
            }
          },
          error_403: {
            type: 'object',
            properties: {
              error: { type: 'string', example: 'Forbidden' }
            }
          },
          error_404: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    title: { type: 'string', example: 'Record not found' },
                    detail: { type: 'string', example: 'The record identified by 123 could not be found.' },
                    code: { type: 'string', example: JSONAPI::RECORD_NOT_FOUND },
                    status: { type: 'string', example: '404' }
                  }
                }
              }
            }
          },
          error_406: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    title: { type: 'string', example: 'Not acceptable' },
                    detail: { type: 'string',
                              example: "All requests must use the 'application/vnd.api+json' Accept without media type parameters. This request specified 'application/json'." }, # rubocop:disable Layout/LineLength
                    code: { type: 'string', example: JSONAPI::NOT_ACCEPTABLE },
                    status: { type: 'string', example: '406' }
                  }
                }
              }
            }
          },
          error_415: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    title: { type: 'string', example: 'Unsupported media type' },
                    detail: { type: 'string',
                              example: "All requests that create or update must use the 'application/vnd.api+json' Content-Type. This request specified 'application/json'." }, # rubocop:disable Layout/LineLength
                    code: { type: 'string', example: JSONAPI::UNSUPPORTED_MEDIA_TYPE },
                    status: { type: 'string', example: '415' }
                  }
                }
              }
            }
          },
          error_422: {
            type: 'object',
            properties: {
              error: { type: 'string', example: 'Invalid request' }
            }
          },
          error_422_start_end_time: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    title: { type: 'string', example: 'must occur after start time' },
                    detail: { type: 'string', example: 'end_time - must occur after start time' },
                    code: { type: 'string', example: JSONAPI::VALIDATION_ERROR },
                    status: { type: 'string', example: '422' }
                  }
                }
              }
            }
          },
          error_422_password_too_short: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  title: 'is too short (minimum is 6 characters)',
                  detail: 'password - is too short (minimum is 6 characters)',
                  code: JSONAPI::VALIDATION_ERROR,
                  source: {
                    pointer: '/data/attributes/password'
                  },
                  status: '422'
                }
              }
            }
          },
          error_423: {
            type: 'object',
            properties: {
              error: { type: 'string', example: 'Record Locked' }
            }
          }
        }
      end
    end
  end
end

# rubocop:enable Naming/VariableNumber
