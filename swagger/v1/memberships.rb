module Swagger
  module V1
    class Memberships
      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          membership_attributes: {
            type: 'object',
            properties: {
              user_id: { type: 'integer', example: 1234, 'x-nullable': false },
              user_group_id: { type: 'integer', example: 13, 'x-nullable': false },
              role: { type: 'string', example: 'member', 'x-nullable': false }
            }
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
                  attributes: { '$ref' => '#/definitions/membership_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
