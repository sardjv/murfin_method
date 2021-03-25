module Swagger
  module V1
    class TimeRanges
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          time_range_attributes: {
            type: 'object',
            properties: {
              start_time: { type: 'string', example: DateTime.parse('2021-01-22 09:00:00').iso8601, 'x-nullable': false },
              end_time: { type: 'string', example: DateTime.parse('2021-01-22 09:45:00').iso8601, 'x-nullable': false },
              user_id: { type: 'integer', example: 123, 'x-nullable': false },
              minutes_worked: { type: 'integer', example: 45, 'x-nullable': false },
              time_range_type_id: { type: 'integer', example: 1, 'x-nullable': false },
              appointment_id: { type: 'string', example: '12345678', 'x-nullable': true }
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
          }
        }
      end
    end
  end
end
