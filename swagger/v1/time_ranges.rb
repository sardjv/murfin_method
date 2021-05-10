module Swagger
  module V1
    class TimeRanges
      def self.time_range_properties
        {
          start_time: { type: 'string', required: true, example: DateTime.parse('2021-01-22 09:00:00').iso8601, 'x-nullable': false },
          end_time: { type: 'string', required: true, example: DateTime.parse('2021-01-22 09:45:00').iso8601, 'x-nullable': false },
          user_id: { type: 'integer', required: false, example: 123, 'x-nullable': false },
          minutes_worked: { type: 'integer', required: true, example: 45, 'x-nullable': false },
          time_range_type_id: { type: 'integer', required: false, example: 1, 'x-nullable': false },
          appointment_id: { type: 'string', required: false, example: '33445566', 'x-nullable': true }
        }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          time_range_attributes: {
            type: 'object',
            properties: time_range_properties
          },
          time_range_attributes_with_user_epr_uuid: {
            type: 'object',
            properties: time_range_properties.merge({ user_epr_uuid: { type: 'string', required: false, example: '01234567890',
                                                                       'x-nullable': false } })
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
          time_range_response_with_relationships: {
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
                  attributes: { '$ref' => '#/definitions/time_range_attributes' },
                  relationships: {
                    type: 'object',
                    properties: {
                      tags: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '105' },
                                type: { type: 'string', example: 'tags' }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
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
                  attributes: { '$ref' => '#/definitions/time_range_attributes_with_user_epr_uuid' },
                  relationships: {
                    type: 'object',
                    properties: {
                      tags: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '105' },
                                type: { type: 'string', example: 'tags' }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end
