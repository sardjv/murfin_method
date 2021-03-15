module Swagger
  module V1
    class TagAssociations
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          tag_association_attributes: {
            type: 'object',
            properties: {
              tag_id: { type: 'integer', example: 100, 'x-nullable': true },
              tag_type_id: { type: 'integer', required: true, example: 200, 'x-nullable': false },
              taggable_id: { type: 'integer', required: true, example: 123, 'x-nullable': false },
              taggable_type: { type: 'string', required: true, example: 'TimeRange', 'x-nullable': false }
            }
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
                  attributes: { '$ref' => '#/definitions/tag_association_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
