-- Governance proposal lifecycle projection for indexed Soroban events.
CREATE TABLE IF NOT EXISTS governance_proposals (
  contract_id TEXT NOT NULL,
  proposal_id BIGINT NOT NULL,
  proposer TEXT,
  status TEXT NOT NULL DEFAULT 'created'
    CHECK (status IN ('created', 'voting', 'timelock', 'executed', 'expired')),
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  executed_at TIMESTAMPTZ,
  expired_at TIMESTAMPTZ,
  PRIMARY KEY (contract_id, proposal_id)
);

CREATE TABLE IF NOT EXISTS governance_proposal_votes (
  contract_id TEXT NOT NULL,
  proposal_id BIGINT NOT NULL,
  voter TEXT NOT NULL,
  vote_count INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (contract_id, proposal_id, voter),
  FOREIGN KEY (contract_id, proposal_id)
    REFERENCES governance_proposals (contract_id, proposal_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_governance_proposals_status_updated
  ON governance_proposals (status, updated_at DESC);

-- Down Migration
DROP TABLE IF EXISTS governance_proposal_votes;
DROP TABLE IF EXISTS governance_proposals;
