module Swagger
  module V1
    class Activities
      SCHEDULE_YAML_EXAMPLE = "---\n:start_time: 2021-03-29 08:00:00.000000000 +01:00\n:end_time: 2021-03-29 12:00:00.000000000 +01:00\n:rrules:\n- :validations:\n    :day:\n    - 1\n  :rule_type: IceCube::WeeklyRule\n  :interval: 1\n  :week_start: 1\n:rtimes: []\n:extimes: []\n".freeze # rubocop:disable Layout/LineLength

      def self.activity_properties
        {
          plan_id: { type: 'integer', example: 8765, 'x-nullable': false },
          minutes_per_week: { type: 'integer', example: 240, 'x-nullable': false }
        }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          activity_attributes: {
            type: 'object',
            properties: activity_properties
          },
          activity_attributes_with_schedule_yaml: {
            type: 'object',
            properties: activity_properties.merge( { schedule_yaml: { type: 'string', example: SCHEDULE_YAML_EXAMPLE, 'x-nullable': false } } )
          },
          activity_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'activities' },
                  attributes: { '$ref' => '#/definitions/activity_attributes_with_schedule_yaml' },
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
                                id: { type: 'string', example: '9001' },
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
          activity_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'activities' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/activities/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/activity_attributes' }
                }
              }
            }
          },
          activity_response_with_relationships: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'activities' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example: 'https://job-plan-stats.herokuapp.com/api/v1/activities/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/activity_attributes' },
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
                                id: { type: 'string', example: '9001' },
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
