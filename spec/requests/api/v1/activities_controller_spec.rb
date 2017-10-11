require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V1::ActivitiesController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/activities' do
    let (:request) {'/api/v1/activities'}
    let! (:activity1) {create(:activity)}
    let! (:activity2) {create(:activity)}
    let! (:record_count_before_request) {Activity.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_activity_count_same

      it 'returns all activities' do
        expected =
            {
                data: [
                    {
                        id: activity1.id.to_s,
                        type: 'activities',
                        links: {
                            self: "http://www.example.com#{request}/#{activity1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(activity1.created_at),
                            'updated-at': to_api_timestamp_format(activity1.updated_at),
                            name: activity1.name,
                            'suggested-amount': activity1.suggested_amount
                        },
                        relationships: {
                            transactions: {
                                links: {
                                    self: "http://www.example.com#{request}/#{activity1.id}/relationships/transactions",
                                    related: "http://www.example.com#{request}/#{activity1.id}/transactions"
                                }
                            }
                        }
                    },
                    {
                        id: activity2.id.to_s,
                        type: 'activities',
                        links: {
                            self: "http://www.example.com#{request}/#{activity2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(activity2.created_at),
                            'updated-at': to_api_timestamp_format(activity2.updated_at),
                            name: activity1.name,
                            'suggested-amount': activity1.suggested_amount
                        },
                        relationships: {
                            transactions: {
                                links: {
                                    self: "http://www.example.com#{request}/#{activity2.id}/relationships/transactions",
                                    related: "http://www.example.com#{request}/#{activity2.id}/transactions"
                                }
                            }
                        }
                    }
                ]
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_200_ok
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/activities/:id' do
    let (:request) {"/api/v1/activities/#{activity.id}"}
    let! (:activity) {create(:activity)}
    let! (:record_count_before_request) {Activity.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_activity_count_same

      it 'returns the activity associated with the id' do
        expected =
            {
                data: {
                    id: activity.id.to_s,
                    type: 'activities',
                    links: {
                        self: "http://www.example.com#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(activity.created_at),
                        'updated-at': to_api_timestamp_format(activity.updated_at),
                        name: activity.name,
                        'suggested-amount': activity.suggested_amount
                    },
                    relationships: {
                        transactions: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/transactions",
                                related: "http://www.example.com#{request}/transactions"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_200_ok
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/activities' do
    let (:request) {'/api/v1/activities'}
    let! (:activity) {build(:activity)}
    let! (:record_count_before_request) {Activity.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        post request,
             headers: {
                 'Api-Token': user.api_token,
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'activities',
                     attributes: {
                         name: activity.name,
                         'suggested-amount': activity.suggested_amount
                     }
                 }
             }.to_json
      end

      it 'persists the created activity' do
        new_activity = Activity.find(assigned_id)

        expect(new_activity.name).to eq(activity.name)
        expect(new_activity.suggested_amount).to eq(activity.suggested_amount)
      end

      expect_activity_count_increase

      it 'returns the created activity' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: 'activities',
                    links: {
                        self: "http://www.example.com#{request}/#{assigned_id}"
                    },
                    attributes: {
                        'created-at': assigned_created_at,
                        'updated-at': assigned_updated_at,
                        name: activity.name,
                        'suggested-amount': activity.suggested_amount
                    },
                    relationships: {
                        transactions: {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/transactions",
                                related: "http://www.example.com#{request}/#{assigned_id}/transactions"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_201_created
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
                     type: 'activities',
                     attributes: {
                         name: activity.name,
                         current: activity.suggested_amount
                     }
                 }
             }.to_json
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'activities',
                     attributes: {
                         name: activity.name,
                         current: activity.suggested_amount
                     }
                 }
             }.to_json
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PATCH api/v1/activities/:id' do
    let (:request) {"/api/v1/activities/#{activity.id}"}
    let! (:activity) {create(:activity)}
    let(:edited_name) {'edited name'}
    let(:edited_suggested_amount) {12345}
    let! (:record_count_before_request) {Activity.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      context 'and updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'activities',
                        id: activity.id,
                        attributes: {
                            name: edited_name,
                            'suggested-amount': edited_suggested_amount
                        }
                    }
                }.to_json
        end

        it 'persists the updated activity associated with the id with updated values' do
          updated_activity = Activity.find(activity.id)

          expect(updated_activity.name).to eq(edited_name)
          expect(updated_activity.suggested_amount).to eq(edited_suggested_amount)
        end

        expect_activity_count_same

        it 'returns the updated activity associated with the id with updated values' do
          expected =
              {
                  data: {
                      id: activity.id.to_s,
                      type: 'activities',
                      links: {
                          self: "http://www.example.com#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(activity.created_at),
                          'updated-at': assigned_updated_at,
                          name: edited_name,
                          'suggested-amount': edited_suggested_amount
                      },
                      relationships: {
                          transactions: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/transactions",
                                  related: "http://www.example.com#{request}/transactions"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'and without updated values' do
        before do
          patch request,
                headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
                params: {data: {type: 'activities', id: activity.id}}.to_json
        end

        it 'persists the updated activity associated with the id without updated values' do
          updated_activity = Activity.find(activity.id)

          expect(updated_activity.name).to eq(activity.name)
          expect(updated_activity.suggested_amount).to eq(activity.suggested_amount)
        end

        expect_activity_count_same

        it 'returns the updated activity associated with the id without updated values' do
          expected =
              {
                  data: {
                      id: activity.id.to_s,
                      type: 'activities',
                      links: {
                          self: "http://www.example.com#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(activity.created_at),
                          'updated-at': to_api_timestamp_format(activity.updated_at),
                          name: activity.name,
                          'suggested-amount': activity.suggested_amount
                      },
                      relationships: {
                          transactions: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/transactions",
                                  related: "http://www.example.com#{request}/transactions"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
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
                      type: 'activities',
                      id: activity.id,
                      attributes: {
                          name: edited_name,
                          'suggested-amount': edited_suggested_amount
                      }
                  }
              }.to_json
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: 'activities',
                      id: activity.id,
                      attributes: {
                          name: edited_name,
                          'suggested-amount': edited_suggested_amount
                      }
                  }
              }.to_json
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/activities/:id' do
    let (:request) {"/api/v1/activities/#{activity.id}"}
    let! (:activity) {create(:activity)}
    let! (:record_count_before_request) {Activity.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the activity associated with the id' do
        expect {Activity.find(activity.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_activity_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_activity_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
