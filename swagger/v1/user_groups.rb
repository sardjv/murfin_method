module Swagger
  module V1
    class UserGroups
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          user_group_attributes: {
            type: 'object',
            properties: {
              name: { type: 'string', example: 'Lorems', 'x-nullable': false },
              group_type_id: { type: 'integer', example: 2, 'x-nullable': false }
            }
          },
          user_groups_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'user_groups' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/user_groups/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/user_group_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/user_groups?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/user_groups?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/user_groups?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/user_groups?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          user_group_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'user_groups' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/user_groups/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/user_group_attributes' }
                }
              }
            }
          },
          user_group_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'user_groups' },
                  attributes: { '$ref' => '#/definitions/user_group_attributes' }
                }
              }
            }
          },
          user_group_patch_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '10' },
                  type: { type: 'string', example: 'user_groups' },
                  attributes: { '$ref' => '#/definitions/user_group_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
