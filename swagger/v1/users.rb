module Swagger
  module V1
    class Users
      def self.user_properties_without_admin
        {
          last_name: { type: 'string', example: 'Smith', 'x-nullable': true },
          first_name: { type: 'string', example: 'John', 'x-nullable': true },
          email: { type: 'string', example: 'john.smith@example.com', 'x-nullable': false },
          epr_uuid: { type: 'string', example: '435f9dfe-4e89-4b5a-b63e-9095327c3a6b', 'x-nullable': true }
        }.merge(Api::V1::UserResource.uses_ldap? ? ldap_bind_item : {})
      end

      def self.ldap_bind_item
        { Api::V1::UserResource.ldap_auth_bind_key_field => { type: 'string', example: 'smithjohn', 'x-nullable': true } }
      end

      def self.definitions # rubocop:disable Metrics/MethodLength
        {
          user_attributes: {
            type: 'object',
            properties: user_properties_without_admin.merge({ admin: { type: 'boolean', example: false, 'x-nullable': false } })
          },
          user_attributes_without_admin: {
            type: 'object',
            properties: user_properties_without_admin
          },
          user_attributes_with_password: {
            type: 'object',
            properties: user_properties_without_admin.merge({ password: { type: 'string', example: 'pA$$w0Rd', 'x-nullable': true } })
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
                  attributes: { '$ref' => '#/definitions/user_attributes' }
                }
              }
            }
          }
        }
      end
    end
  end
end
