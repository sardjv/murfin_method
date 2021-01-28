module Swagger
  module V1
    class TagTypes
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          tag_type_attributes: {
            type: 'object',
            properties: {
              name: { type: 'string', example: 'Ipsum', 'x-nullable': false },
              parent_id: { type: 'integer', example: nil, 'x-nullable': true },
              active_for_activities_at: { type: 'string', example: Time.parse('2021-01-28 12:30').iso8601, 'x-nullable': true },
              active_for_time_ranges_at: { type: 'string', example: Time.parse('2021-01-29 9:00').iso8601, 'x-nullable': true }
            }
          },
          tag_types_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'tag_types' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example:
                          'https://job-plan-stats.herokuapp.com/api/v1/tag_types/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/tag_type_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tag_types?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tag_types?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tag_types?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/tag_types?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          tag_type_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'tag_types' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/tag_types/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/tag_type_attributes' }
                }
              }
            }
          },
          tag_type_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'tag_types' },
                  attributes: { '$ref' => '#/definitions/tag_type_attributes' }
                }
              }
            }
          },
          tag_type_patch_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'tag_types' },
                  attributes: { '$ref' => '#/definitions/tag_type_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
