module Swagger
  module V1
    class Users
      # def self.user_properties_without_admin
      #   {
      #     last_name: { type: 'string', example: 'Smith', 'x-nullable': true },
      #     first_name: { type: 'string', example: 'John', 'x-nullable': true },
      #     email: { type: 'string', example: 'john.smith@example.com', 'x-nullable': false },
      #     epr_uuid: { type: 'string', example: '435f9dfe-4e89-4b5a-b63e-9095327c3a6b', 'x-nullable': true },
      #     sign_in_count: { type: 'integer', example: 10, 'x-nullable': false },
      #     current_sign_in_at: { type: 'string', example: Time.parse('2021-08-11 15:30').iso8601, 'x-nullable': false },
      #     last_sign_in_at: { type: 'string', example: Time.parse('2021-08-10 11:15').iso8601, 'x-nullable': false },
      #     current_sign_in_auth_method: { type: 'string', example: 'form', 'x-nullable': false },
      #     last_sign_in_auth_method: { type: 'string', example: 'form', 'x-nullable': false }
      #   }.merge(Api::V1::UserResource.uses_ldap? ? ldap_bind_item : {})
      # end

      def self.user_properties
        {
          last_name: { type: 'string', example: 'Smith', 'x-nullable': true },
          first_name: { type: 'string', example: 'John', 'x-nullable': true },
          email: { type: 'string', example: 'john.smith@example.com', 'x-nullable': false },
          admin: { type: 'boolean', example: false, 'x-nullable': false },
          epr_uuid: { type: 'string', example: '435f9dfe-4e89-4b5a-b63e-9095327c3a6b', 'x-nullable': true },
          sign_in_count: { type: 'integer', example: 10, 'x-nullable': true },
          current_sign_in_at: { type: 'string', example: Time.parse('2021-08-11 15:30').iso8601, 'x-nullable': true },
          last_sign_in_at: { type: 'string', example: Time.parse('2021-08-10 11:15').iso8601, 'x-nullable': true },
          current_sign_in_auth_method: { type: 'string', example: 'form', 'x-nullable': true },
          last_sign_in_auth_method: { type: 'string', example: 'form', 'x-nullable': true }
        }.merge(Api::V1::UserResource.uses_ldap? ? ldap_bind_item : {})
      end

      def self.user_updatable_properties
        user_properties.except(*([:admin] + Api::V1::UserResource::TRACKABLE_FIELDS))
      end

      def self.ldap_bind_item
        { Api::V1::UserResource.ldap_auth_bind_key_field => { type: 'string', example: 'smithjohn', 'x-nullable': true } }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          user_attributes: {
            type: 'object',
            properties: user_properties
          },
          user_updatable_attributes: {
            type: 'object',
            properties: user_updatable_properties
          },
          user_attributes_with_password: {
            type: 'object',
            properties: user_updatable_properties.merge({ password: { type: 'string', example: 'pA$$w0Rd', 'x-nullable': true } })
          },
          users_response: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '1' },
                    type: { type: 'string', example: 'users' },
                    link: {
                      type: 'object',
                      properties: {
                        self: { type: 'string', example:
                          'https://job-plan-stats.herokuapp.com/api/v1/users/1' }
                      }
                    },
                    attributes: { '$ref' => '#/definitions/user_attributes' }
                  }
                }
              },
              links: {
                type: 'object',
                properties: {
                  first: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=1&page[size]=5' },
                  prev: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=1&page[size]=5' },
                  next: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=2&page[size]=5' },
                  last: { type: 'string', example:
                    'https://job-plan-stats.herokuapp.com/api/v1/users?page[number]=5&page[size]=5' }
                }
              }
            }
          },
          user_response: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'users' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/users/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/user_attributes' }
                }
              }
            }
          },
          user_response_with_relationships: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'users' },
                  link: {
                    type: 'object',
                    properties: {
                      self: { type: 'string', example:
                        'https://job-plan-stats.herokuapp.com/api/v1/users/1' }
                    }
                  },
                  attributes: { '$ref' => '#/definitions/user_attributes' },
                  relationships: {
                    type: 'object',
                    properties: {
                      user_groups: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '303' },
                                type: { type: 'string', example: 'user_groups' }
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
          user_post_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  type: { type: 'string', example: 'users' },
                  attributes: { '$ref' => '#/definitions/user_attributes_with_password' },
                  relationships: {
                    type: 'object',
                    properties: {
                      user_groups: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '303' },
                                type: { type: 'string', example: 'user_groups' }
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
          user_patch_params: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'users' },
                  attributes: { '$ref' => '#/definitions/user_attributes_with_password' },
                  relationships: {
                    type: 'object',
                    properties: {
                      user_groups: {
                        properties: {
                          data: {
                            type: 'array',
                            items: {
                              type: 'object',
                              properties: {
                                id: { type: 'string', example: '303' },
                                type: { type: 'string', example: 'user_groups' }
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
          user_patch_params_without_password: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '1' },
                  type: { type: 'string', example: 'users' },
                  attributes: { '$ref' => '#/definitions/user_updatable_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
