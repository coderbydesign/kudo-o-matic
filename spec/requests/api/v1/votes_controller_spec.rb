require 'rails_helper'
require 'shared/api/v1/shared_expectations'

def expect_record_count_same
  it 'does not change the record count' do
    expect(record_count_before_request).to be == Vote.count
  end
end

def expect_record_count_increase
  it 'increases the record count' do
    expect(record_count_before_request).to be < Vote.count
  end
end

def expect_record_count_decrease
  it 'decreases the record count' do
    expect(record_count_before_request).to be > Vote.count
  end
end

RSpec.describe Api::V1::VotesController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/votes' do
    let (:request) {'/api/v1/votes'}
    let! (:vote1) {create(:vote)}
    let! (:vote2) {create(:vote)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Vote.count}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

      it 'returns all votes' do
        expected =
            {
                data: [
                    {
                        id: vote1.id.to_s,
                        type: 'votes',
                        links: {
                            self: "http://www.example.com#{request}/#{vote1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(vote1.created_at),
                            'updated-at': to_api_timestamp_format(vote1.updated_at),
                            'votable-type': vote1.votable_type,
                            'votable-id': vote1.votable_id,
                            'voter-type': vote1.voter_type,
                            'voter-id': vote1.voter_id,
                            'vote-flag': vote1.vote_flag,
                            'vote-scope': vote1.vote_scope,
                            'vote-weight': vote1.vote_weight
                        },
                        relationships: {
                            'user-voter': {
                                links: {
                                    self: "http://www.example.com#{request}/#{vote1.id}/relationships/user-voter",
                                    related: "http://www.example.com#{request}/#{vote1.id}/user-voter"
                                }
                            },
                            'transaction-votable': {
                                links: {
                                    self: "http://www.example.com#{request}/#{vote1.id}/relationships/transaction-votable",
                                    related: "http://www.example.com#{request}/#{vote1.id}/transaction-votable"
                                }
                            }
                        }
                    },
                    {
                        id: vote2.id.to_s,
                        type: 'votes',
                        links: {
                            self: "http://www.example.com#{request}/#{vote2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(vote2.created_at),
                            'updated-at': to_api_timestamp_format(vote2.updated_at),
                            'votable-type': vote2.votable_type,
                            'votable-id': vote2.votable_id,
                            'voter-type': vote2.voter_type,
                            'voter-id': vote2.voter_id,
                            'vote-flag': vote2.vote_flag,
                            'vote-scope': vote2.vote_scope,
                            'vote-weight': vote2.vote_weight
                        },
                        relationships: {
                            'user-voter': {
                                links: {
                                    self: "http://www.example.com#{request}/#{vote2.id}/relationships/user-voter",
                                    related: "http://www.example.com#{request}/#{vote2.id}/user-voter"
                                }
                            },
                            'transaction-votable': {
                                links: {
                                    self: "http://www.example.com#{request}/#{vote2.id}/relationships/transaction-votable",
                                    related: "http://www.example.com#{request}/#{vote2.id}/transaction-votable"
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
      let! (:record_count_before_request) {Vote.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/votes/:id' do
    let (:request) {"/api/v1/votes/#{vote.id}"}
    let! (:vote) {create(:vote)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Vote.count}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

      it 'returns the vote associated with the id' do
        expected =
            {
                data: {
                    id: vote.id.to_s,
                    type: 'votes',
                    links: {
                        self: "http://www.example.com#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(vote.created_at),
                        'updated-at': to_api_timestamp_format(vote.updated_at),
                        'votable-type': vote.votable_type,
                        'votable-id': vote.votable_id,
                        'voter-type': vote.voter_type,
                        'voter-id': vote.voter_id,
                        'vote-flag': vote.vote_flag,
                        'vote-scope': vote.vote_scope,
                        'vote-weight': vote.vote_weight
                    },
                    relationships: {
                        'user-voter': {
                            links: {
                                self: "http://www.example.com#{request}/relationships/user-voter",
                                related: "http://www.example.com#{request}/user-voter"
                            }
                        },
                        'transaction-votable': {
                            links: {
                                self: "http://www.example.com#{request}/relationships/transaction-votable",
                                related: "http://www.example.com#{request}/transaction-votable"
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
      let! (:record_count_before_request) {Vote.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/votes' do
    let (:request) {'/api/v1/votes'}
    let! (:vote) {build(:vote)}
    let! (:record_count_before_request) {Vote.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Vote.count}

      before do
        post request,
             headers: {
                 'Api-Token': user.api_token,
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'votes',
                     attributes: {
                         'votable-type': vote.votable_type,
                         'votable-id': vote.votable_id,
                         'voter-type': vote.voter_type,
                         'voter-id': vote.voter_id,
                         'vote-flag': vote.vote_flag,
                         'vote-scope': vote.vote_scope,
                         'vote-weight': vote.vote_weight
                     }
                 }
             }.to_json
      end

      it 'persists the created vote' do
        new_vote = Vote.find(assigned_id)

        expect(new_vote.votable_type).to eq(vote.votable_type)
        expect(new_vote.votable_id).to eq(vote.votable_id)
        expect(new_vote.voter_type).to eq(vote.voter_type)
        expect(new_vote.voter_id).to eq(vote.voter_id)
        expect(new_vote.vote_flag).to eq(vote.vote_flag)
        expect(new_vote.vote_scope).to eq(vote.vote_scope)
        expect(new_vote.vote_weight).to eq(vote.vote_weight)
      end

      expect_record_count_increase

      it 'returns the created vote' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: 'votes',
                    links: {
                        self: "http://www.example.com#{request}/#{assigned_id}"
                    },
                    attributes: {
                        'created-at': assigned_created_at,
                        'updated-at': assigned_updated_at,
                        'votable-type': vote.votable_type,
                        'votable-id': vote.votable_id,
                        'voter-type': vote.voter_type,
                        'voter-id': vote.voter_id,
                        'vote-flag': vote.vote_flag,
                        'vote-scope': vote.vote_scope,
                        'vote-weight': vote.vote_weight
                    },
                    relationships: {
                        'user-voter': {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/user-voter",
                                related: "http://www.example.com#{request}/#{assigned_id}/user-voter"
                            }
                        },
                        'transaction-votable': {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/transaction-votable",
                                related: "http://www.example.com#{request}/#{assigned_id}/transaction-votable"
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
      let! (:record_count_before_request) {Vote.count}

      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'votes',
                     attributes: {
                         'votable-type': vote.votable_type,
                         'votable-id': vote.votable_id,
                         'voter-type': vote.voter_type,
                         'voter-id': vote.voter_id,
                         'vote-flag': vote.vote_flag,
                         'vote-scope': vote.vote_scope,
                         'vote-weight': vote.vote_weight
                     }
                 }
             }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'votes',
                     attributes: {
                         'votable-type': vote.votable_type,
                         'votable-id': vote.votable_id,
                         'voter-type': vote.voter_type,
                         'voter-id': vote.voter_id,
                         'vote-flag': vote.vote_flag,
                         'vote-scope': vote.vote_scope,
                         'vote-weight': vote.vote_weight
                     }
                 }
             }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PATCH api/v1/votes/:id' do
    let (:request) {"/api/v1/votes/#{vote.id}"}
    let! (:vote) {create(:vote)}
    let(:edited_votable_type) {'edited votable type'}
    let(:edited_votable_id) {12345}
    let(:edited_voter_type) {'edited voter type'}
    let(:edited_voter_id) {67890}
    let(:edited_vote_flag) {true}
    let(:edited_vote_scope) {'edited vote scope'}
    let(:edited_vote_weight) {1}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      context 'and updated values' do
        let! (:record_count_before_request) {Vote.count}

        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'votes',
                        id: vote.id,
                        attributes: {
                            'votable-type': edited_votable_type,
                            'votable-id': edited_votable_id,
                            'voter-type': edited_voter_type,
                            'voter-id': edited_voter_id,
                            'vote-flag': edited_vote_flag,
                            'vote-scope': edited_vote_scope,
                            'vote-weight': edited_vote_weight
                        }
                    }
                }.to_json
        end

        it 'persists the updated vote associated with the id with updated values' do
          updated_vote = Vote.find(vote.id)

          expect(updated_vote.votable_type).to eq(edited_votable_type)
          expect(updated_vote.votable_id).to eq(edited_votable_id)
          expect(updated_vote.voter_type).to eq(edited_voter_type)
          expect(updated_vote.voter_id).to eq(edited_voter_id)
          expect(updated_vote.vote_flag).to eq(edited_vote_flag)
          expect(updated_vote.vote_scope).to eq(edited_vote_scope)
          expect(updated_vote.vote_weight).to eq(edited_vote_weight)
        end

        expect_record_count_same

        it 'returns the updated vote associated with the id with updated values' do
          expected =
              {
                  data: {
                      id: vote.id.to_s,
                      type: 'votes',
                      links: {
                          self: "http://www.example.com#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(vote.created_at),
                          'updated-at': assigned_updated_at,
                          'votable-type': edited_votable_type,
                          'votable-id': edited_votable_id,
                          'voter-type': edited_voter_type,
                          'voter-id': edited_voter_id,
                          'vote-flag': edited_vote_flag,
                          'vote-scope': edited_vote_scope,
                          'vote-weight': edited_vote_weight
                      },
                      relationships: {
                          'user-voter': {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/user-voter",
                                  related: "http://www.example.com#{request}/user-voter"
                              }
                          },
                          'transaction-votable': {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/transaction-votable",
                                  related: "http://www.example.com#{request}/transaction-votable"
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
        let! (:record_count_before_request) {Vote.count}

        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'votes',
                        id: vote.id
                    }
                }.to_json
        end

        it 'persists the updated vote associated with the id without updated values' do
          updated_vote = Vote.find(vote.id)

          expect(updated_vote.votable_type).to eq(vote.votable_type)
          expect(updated_vote.votable_id).to eq(vote.votable_id)
          expect(updated_vote.voter_type).to eq(vote.voter_type)
          expect(updated_vote.voter_id).to eq(vote.voter_id)
          expect(updated_vote.vote_flag).to eq(vote.vote_flag)
          expect(updated_vote.vote_scope).to eq(vote.vote_scope)
          expect(updated_vote.vote_weight).to eq(vote.vote_weight)
        end

        expect_record_count_same

        it 'returns the updated vote associated with the id without updated values' do
          expected =
              {
                  data: {
                      id: vote.id.to_s,
                      type: 'votes',
                      links: {
                          self: "http://www.example.com#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(vote.created_at),
                          'updated-at': to_api_timestamp_format(vote.updated_at),
                          'votable-type': vote.votable_type,
                          'votable-id': vote.votable_id,
                          'voter-type': vote.voter_type,
                          'voter-id': vote.voter_id,
                          'vote-flag': vote.vote_flag,
                          'vote-scope': vote.vote_scope,
                          'vote-weight': vote.vote_weight
                      },
                      relationships: {
                          'user-voter': {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/user-voter",
                                  related: "http://www.example.com#{request}/user-voter"
                              }
                          },
                          'transaction-votable': {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/transaction-votable",
                                  related: "http://www.example.com#{request}/transaction-votable"
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
      let! (:record_count_before_request) {Vote.count}

      before do
        patch request,
              headers: {
                  'Api-Token': 'invalid api-token',
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: 'votes',
                      id: vote.id,
                      attributes: {
                          'votable-type': edited_votable_type,
                          'votable-id': edited_votable_id,
                          'voter-type': edited_voter_type,
                          'voter-id': edited_voter_id,
                          'vote-flag': edited_vote_flag,
                          'vote-scope': edited_vote_scope,
                          'vote-weight': edited_vote_weight
                      }
                  }
              }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: 'votes',
                      id: vote.id,
                      attributes: {
                          'votable-type': edited_votable_type,
                          'votable-id': edited_votable_id,
                          'voter-type': edited_voter_type,
                          'voter-id': edited_voter_id,
                          'vote-flag': edited_vote_flag,
                          'vote-scope': edited_vote_scope,
                          'vote-weight': edited_vote_weight
                      }
                  }
              }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/votes/:id' do
    let (:request) {"/api/v1/votes/#{vote.id}"}
    let! (:vote) {create(:vote)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the vote associated with the id' do
        expect {Vote.find(vote.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_record_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
