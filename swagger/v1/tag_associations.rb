module Swagger
  module V1
    class TagAssociations
      def self.tag_association_properties
        {
          tag_id: { type: 'integer', required: false, example: 100, 'x-nullable': true },
          tag_type_id: { type: 'integer', required: true, example: 200, 'x-nullable': false },
          taggable_id: { type: 'integer', required: false, example: 123, 'x-nullable': false },
          taggable_type: { type: 'string', required: false, example: 'TimeRange', 'x-nullable': false }
        }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          tag_association_attributes: {
            type: 'object',
            properties: tag_association_properties
          },
          tag_association_post_attributes: {
            type: 'object',
            properties: tag_association_properties.except(:tag_type_id)
                                                  .merge({ time_range_appointment_id: { type: 'string', required: false, example: 'lorem123',
                                                                                        'x-nullable': true } })
          },
          tag_association_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'tag_associations' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/tag_associations/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/tag_association_attributes' }
                }
              }
            }
          },
          tag_association_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'tag_associations' },
                  attributes: { '$ref' => '#/definitions/tag_association_post_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
