module Swagger
  module V1
    class Plans
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          plan_attributes: {
            type: 'object',
            properties: {
              start_date: { type: 'string', example: Date.parse('2021-01-01').iso8601, 'x-nullable': false },
              end_date: { type: 'string', example: Date.parse('2021-12-31').iso8601, 'x-nullable': false },
              user_id: { type: 'integer', example: 321, 'x-nullable': false },
              contracted_minutes_per_week: { type: 'integer', example: 60 * 15, 'x-nullable': false }
            }
          },
          plan_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'plans' },
                  attributes: { '$ref' => '#/definitions/plan_attributes' }
                }
              }
            }
          },
          plans_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'plans' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/plans/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/plan_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/plans?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/plans?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/plans?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/plans?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          plan_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'plans' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/plans/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/plan_attributes' }
                }
              }
            }
          },
          plan_response_with_relationships: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'plans' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/plans/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/plan_attributes' },
                  relationships: {
                    type: 'object',
                    properties: {
                      activities: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '321' },
                                type: { type: 'string', example: 'activities' }
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
