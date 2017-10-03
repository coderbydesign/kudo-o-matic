require 'rails_helper'
require 'shared/api/v1/unauthorized'

RSpec.describe Api::V1::GoalsController, type: :request do
  include RequestHelpers

  let (:host) {'http://www.example.com'}
  let (:resource_type) {'goals'}
  let (:relationship_type_balance) {'balance'}

  describe 'GET api/v1/goals' do
    let (:request) {'/api/v1/goals'}
    let! (:goal1) {create(:goal)}
    let! (:goal2) {create(:goal)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns all goals' do
        expected =
            {
                data: [
                    {
                        id: goal1.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{goal1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(goal1.created_at),
                            'updated-at': to_api_timestamp_format(goal1.updated_at),
                            name: goal1.name,
                            amount: goal1.amount,
                            'achieved-on': goal1.achieved_on
                        },
                        relationships: {
                            balance: {
                                links: {
                                    self: "#{host}#{request}/#{goal1.id}/relationships/#{relationship_type_balance}",
                                    related: "#{host}#{request}/#{goal1.id}/#{relationship_type_balance}"
                                }
                            }
                        }
                    },
                    {
                        id: goal2.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{goal2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(goal2.created_at),
                            'updated-at': to_api_timestamp_format(goal2.updated_at),
                            name: goal2.name,
                            amount: goal2.amount,
                            'achieved-on': goal2.achieved_on
                        },
                        relationships: {
                            balance: {
                                links: {
                                    self: "#{host}#{request}/#{goal2.id}/relationships/#{relationship_type_balance}",
                                    related: "#{host}#{request}/#{goal2.id}/#{relationship_type_balance}"
                                }
                            }
                        }
                    }
                ]
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it {expect(response).to have_http_status(200)}
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'GET api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns the goal associated with the id' do
        expected =
            {
                data: {
                    id: goal.id.to_s,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(goal.created_at),
                        'updated-at': to_api_timestamp_format(goal.updated_at),
                        name: goal.name,
                        amount: goal.amount,
                        'achieved-on': goal.achieved_on
                    },
                    relationships: {
                        balance: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_balance}",
                                related: "#{host}#{request}/#{relationship_type_balance}"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'POST api/v1/goals' do
    let (:request) {'/api/v1/goals'}
    let! (:goal) {build(:goal)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        post request,
             headers: {
                 'Api-Token': user.api_token,
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: goal.name,
                         amount: goal.amount,
                         'achieved-on': goal.achieved_on
                     }
                 }
             }.to_json
      end

      it 'returns the newly created goal' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}/#{assigned_id}"
                    },
                    attributes: {
                        'created-at': assigned_created_at,
                        'updated-at': assigned_updated_at,
                        name: goal.name,
                        amount: goal.amount,
                        'achieved-on': goal.achieved_on
                    },
                    relationships: {
                        balance: {
                            links: {
                                self: "#{host}#{request}/#{assigned_id}/relationships/#{relationship_type_balance}",
                                related: "#{host}#{request}/#{assigned_id}/#{relationship_type_balance}"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'persists the newly created goal' do
        new_goal = Goal.find(assigned_id)

        expect(new_goal.achieved_on).to eq(goal.achieved_on)
        expect(new_goal.name).to eq(goal.name)
        expect(new_goal.amount).to eq(goal.amount)
      end

      it 'returns a 201 (created) status code' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with an invalid api-token' do
      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: goal.name,
                         amount: goal.amount,
                         'achieved-on': goal.achieved_on
                     }
                 }
             }.to_json
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: goal.name,
                         amount: goal.amount,
                         'achieved-on': goal.achieved_on
                     }
                 }
             }.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'PATCH api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}
    let(:edited_name) {'edited name'}
    let(:edited_amount) {12345}
    let(:edited_achieved_on) {'2015-01-01'}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      context 'and updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'goals',
                        id: goal.id,
                        attributes: {
                            name: edited_name,
                            amount: edited_amount,
                            'achieved-on': edited_achieved_on
                        }
                    }
                }.to_json
        end

        it 'returns the updated goal associated with the id with updated values' do
          expected =
              {
                  data: {
                      id: goal.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(goal.created_at),
                          'updated-at': assigned_updated_at,
                          name: edited_name,
                          amount: edited_amount,
                          'achieved-on': edited_achieved_on
                      },
                      relationships: {
                          balance: {
                              links: {
                                  self: "#{host}#{request}/relationships/#{relationship_type_balance}",
                                  related: "#{host}#{request}/#{relationship_type_balance}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the updated goal with updated values' do
          updated_goal = Goal.find(goal.id)

          expect(updated_goal.achieved_on.to_s).to eq(edited_achieved_on)
          expect(updated_goal.name).to eq(edited_name)
          expect(updated_goal.amount).to eq(edited_amount)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and without updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'goals',
                        id: goal.id
                    }
                }.to_json
        end

        it 'returns the updated goal associated with the id without updated values' do
          expected =
              {
                  data: {
                      id: goal.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(goal.created_at),
                          'updated-at': to_api_timestamp_format(goal.updated_at),
                          name: goal.name,
                          amount: goal.amount,
                          'achieved-on': goal.achieved_on
                      },
                      relationships: {
                          balance: {
                              links: {
                                  self: "#{host}#{request}/relationships/#{relationship_type_balance}",
                                  related: "#{host}#{request}/#{relationship_type_balance}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the updated goal without updated values' do
          updated_goal = Goal.find(goal.id)

          expect(updated_goal.achieved_on).to eq(goal.achieved_on)
          expect(updated_goal.name).to eq(goal.name)
          expect(updated_goal.amount).to eq(goal.amount)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'with an invalid api-token' do
      before do
        patch request,
              headers: {
                  'Api-Token': 'invalid api-token',
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: resource_type,
                      id: goal.id,
                      attributes: {
                          name: edited_name,
                          amount: edited_amount
                      }
                  }
              }.to_json
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: resource_type,
                      id: goal.id,
                      attributes: {
                          name: edited_name,
                          amount: edited_amount
                      }
                  }
              }.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'DELETE api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the goal associated with the id' do
        expect {Goal.find(goal.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a 204 (no content) status code' do
        expect(response).to have_http_status(204)
      end
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'GET api/v1/goals/next' do
    let (:request) {'/api/v1/goals/next'}
    let! (:balance) {create(:balance, :current)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let(:no_next_goal_achieved_on) {nil}
      let(:no_next_goal_name) {'TBD'}
      let(:no_next_goal_amount) {1000}

      context 'and a next goal that is not achieved' do
        let! (:goal) {create(:goal, balance: balance)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the next goal' do
          expected =
              {
                  data: {
                      id: goal.id,
                      type: resource_type,
                      attributes: {
                          'created-at': to_api_timestamp_format(goal.created_at),
                          'updated-at': to_api_timestamp_format(goal.updated_at),
                          name: goal.name,
                          amount: goal.amount,
                          'achieved-on': goal.achieved_on
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and a next goal that is achieved' do
        let! (:goal) {create(:goal, :achieved, balance: balance)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'creates a new goal that is to be defined' do
          expected =
              {
                  data: {
                      id: assigned_id,
                      type: resource_type,
                      attributes: {
                          'created-at': assigned_created_at,
                          'updated-at': assigned_updated_at,
                          name: no_next_goal_name,
                          amount: goal.amount + no_next_goal_amount,
                          'achieved-on': no_next_goal_achieved_on
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and no next goal' do
        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'creates a new goal that is to be defined' do
          expected =
              {
                  data: {
                      id: assigned_id,
                      type: resource_type,
                      attributes: {
                          'created-at': assigned_created_at,
                          'updated-at': assigned_updated_at,
                          name: no_next_goal_name,
                          amount: no_next_goal_amount,
                          'achieved-on': no_next_goal_achieved_on
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'GET api/v1/goals/previous' do
    let (:request) {'/api/v1/goals/previous'}
    let! (:balance) {create(:balance, :current)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      context 'and a previous goal' do
        let! (:goal1) {create(:goal, :achieved, balance: balance)}
        let! (:goal2) {create(:goal, balance: balance)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the previous goal' do
          expected =
              {
                  data: {
                      id: goal1.id,
                      type: resource_type,
                      attributes: {
                          'created-at': to_api_timestamp_format(goal1.created_at),
                          'updated-at': to_api_timestamp_format(goal1.updated_at),
                          name: goal1.name,
                          amount: goal1.amount,
                          'achieved-on': goal1.achieved_on.to_s
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and no previous goal' do
        let(:no_previous_goal_achieved_on) {nil}
        let(:no_previous_goal_name) {'N/A'}
        let(:no_previous_goal_amount) {0}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns a not available response' do
          expected =
              {
                  data: {
                      id: nil,
                      type: resource_type,
                      attributes: {
                          'created-at': assigned_created_at,
                          'updated-at': assigned_updated_at,
                          name: no_previous_goal_name,
                          amount: no_previous_goal_amount,
                          'achieved-on': no_previous_goal_achieved_on
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end
end
