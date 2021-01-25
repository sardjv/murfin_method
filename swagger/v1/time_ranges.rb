module Swagger
  module V1
    class TimeRanges
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          time_range_attributes: {
            type: 'object',
            properties: {
              start_time: { type: 'string', example: Date.parse('2021-01-22').beginning_of_day.iso8601, 'x-nullable': false },
              end_time: { type: 'string', example: Date.parse('2021-01-24').end_of_day.iso8601, 'x-nullable': false },
              user_id: { type: 'integer', example: 123, 'x-nullable': false },
              seconds_worked: { type: 'string', example: (3600 * 16).to_s, 'x-nullable': false },
              time_range_type_id: { type: 'integer', example: 567, 'x-nullable': false }
            }
          },
          time_ranges_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'time_ranges' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/time_ranges/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/time_range_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/time_ranges?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/time_ranges?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/time_ranges?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/time_ranges?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          time_range_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'time_ranges' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/time_ranges/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/time_range_attributes' }
                }
              }
            }
          },
          time_range_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'time_ranges' },
                  attributes: { '$ref' => '#/definitions/time_range_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
