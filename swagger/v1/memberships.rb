module Swagger
  module V1
    class Memberships
      def self.membership_properties
        {
          user_id: { type: 'integer', required: false, example: 1234, 'x-nullable': false },
          user_group_id: { type: 'integer', required: true, example: 13, 'x-nullable': false },
          role: { type: 'string', required: true, example: 'member', 'x-nullable': false }
        }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          membership_attributes: {
            type: 'object',
            properties: membership_properties
          },
          membership_attributes_with_user_epr_uuid: {
            type: 'object',
            properties: membership_properties.merge({ user_epr_uuid: { type: 'string', required: false, example: '01234567890',
                                                                       'x-nullable': false } })
          },
          membership_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '123' },
                  type: { type: 'string', example: 'memberships' },
                  attributes: { '$ref' => '#/definitions/membership_attributes' }
                }
              }
            }
          },
          membership_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'memberships' },
                  attributes: { '$ref' => '#/definitions/membership_attributes_with_user_epr_uuid' }
                }
              }
            }
          }
        }
      end
    end
  end
end
