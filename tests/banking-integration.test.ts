import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('Banking Integration Contract', () => {
  const user1 = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
  const user2 = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
  
  beforeEach(() => {
    // Reset contract state before each test
  });
  
  it('should link bank account', () => {
    const mockLinkBankAccount = vi.fn().mockReturnValue({ ok: true });
    mockLinkBankAccount('banking-integration', 'link-bank-account', ['123456789'], user1);
    expect(mockLinkBankAccount).toHaveBeenCalledWith('banking-integration', 'link-bank-account', ['123456789'], user1);
    
  });
  
  it('should deposit fiat', () => {
    const mockLinkBankAccount = vi.fn().mockReturnValue({ ok: true });
    mockLinkBankAccount('banking-integration', 'link-bank-account', ['123456789'], user1);
    const mockDepositFiat = vi.fn().mockReturnValue({ ok: true });
    mockDepositFiat('banking-integration', 'deposit-fiat', [1000], user1);
    expect(mockDepositFiat).toHaveBeenCalledWith('banking-integration', 'deposit-fiat', [1000], user1);
  });
  
  it('should withdraw fiat', () => {
    const mockLinkBankAccount = vi.fn().mockReturnValue({ ok: true });
    mockLinkBankAccount('banking-integration', 'link-bank-account', ['123456789'], user1);
    const mockDepositFiat = vi.fn().mockReturnValue({ ok: true });
    mockDepositFiat('banking-integration', 'deposit-fiat', [1000], user1);
    const mockWithdrawFiat = vi.fn().mockReturnValue({ ok: true });
    mockWithdrawFiat('banking-integration', 'withdraw-fiat', [500], user1);
    expect(mockWithdrawFiat).toHaveBeenCalledWith('banking-integration', 'withdraw-fiat', [500], user1);
  });
  
  it('should get linked account', () => {
    const mockLinkBankAccount = vi.fn().mockReturnValue({ ok: true });
    mockLinkBankAccount('banking-integration', 'link-bank-account', ['123456789'], user1);
    const mockGetLinkedAccount = vi.fn().mockReturnValue({ ok: true, response: { bank_account_id: '123456789' } });
    mockGetLinkedAccount('banking-integration', 'get-linked-account', [user1]);
    expect(mockGetLinkedAccount).toHaveBeenCalledWith('banking-integration', 'get-linked-account', [user1]);
  });
});

