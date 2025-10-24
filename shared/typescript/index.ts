// Shared TypeScript types for Prohesis

export interface Market {
  id: string;
  question: string;
  endTime: number;
  volume: string;
  resolved: boolean;
  winningOutcome?: number;
  outcomes?: string[];
}

export interface CreateMarketRequest {
  question: string;
  endTime: number;
  outcomes: string[];
}

export interface GetMarketsResponse {
  markets: Market[];
  totalCount: number;
}

export interface Payout {
  marketId: string;
  userAddress: string;
  outcome: number;
  amount: string;
  timestamp: number;
}

export interface RedeemRequest {
  marketId: string;
  userAddress: string;
}

export interface RedeemResponse {
  success: boolean;
  transactionHash: string;
  amount: string;
}
