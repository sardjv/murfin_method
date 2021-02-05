module Swagger
  module V1
    class Tags
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          tag_attributes: {
            type: 'object',
            properties: {
              name: { type: 'string', example: 'Lorem', 'x-nullable': false },
              tag_type_id: { type: 'integer', example: 4567, 'x-nullable': false },
              parent_id: { type: 'integer', example: 98_765, 'x-nullable': true },
              default_for_filter: { type: 'boolean', example: false, 'x-nullable': false }
            }
          },
          tags_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'tags' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example:
                          'https://job-plan-stats.herokuapp.com/api/v1/tags/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/tag_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tags?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tags?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tags?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tags?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          tag_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'tags' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/tags/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/tag_attributes' }
                }
              }
            }
          },
          tag_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'tags' },
                  attributes: { '$ref' => '#/definitions/tag_attributes' }
                }
              }
            }
          },
          tag_patch_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'tags' },
                  attributes: { '$ref' => '#/definitions/tag_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
