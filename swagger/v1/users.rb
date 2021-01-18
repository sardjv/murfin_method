module Swagger
  module V1
    class Users
      def self.definitions
        {
          user_attributes: {
            type: 'object',
            properties: {
              last_name: { type: 'string', example: 'Smith', 'x-nullable': true },
              first_name: { type: 'string', example: 'John', 'x-nullable': true },
              email: { type: 'string', example: 'john.smith@example.com', 'x-nullable': true }
            }
          },
          users_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'Users' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example:
                          'https://job-plan-stats.herokuapp.com/api/v1/users/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/user_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          user_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'Users' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/users/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/user_attributes' }
                }
              }
            }
          },
          user_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'users' },
                  attributes: { '$ref' => '#/definitions/user_attributes' }
                }
              }
            }
          },
          user_patch_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'users' },
                  attributes: { '$ref' => '#/definitions/user_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
