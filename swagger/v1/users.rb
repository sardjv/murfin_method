module Swagger
  module V1
    class Users

      def self.user_properties_without_admin
        {
          last_name: { type: 'string', example: 'Smith', 'x-nullable': true },
          first_name: { type: 'string', example: 'John', 'x-nullable': true },
          email: { type: 'string', example: 'john.smith@example.com', 'x-nullable': false }
        }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          user_attributes: {
            type: 'object',
            properties: user_properties_without_admin.merge( { admin: { type: 'boolean', example: false, 'x-nullable': false } } )
          },
          user_attributes_without_admin: {
            type: 'object',
            properties: user_properties_without_admin
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
                  attributes: { '$ref' => '#/definitions/user_attributes_without_admin' }
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
                  attributes: { '$ref' => '#/definitions/user_attributes_without_admin' }
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
                  attributes: { '$ref' => '#/definitions/user_attributes_without_admin' }
                }
              }
            }
          }
        }
      end
    end
  end
end
