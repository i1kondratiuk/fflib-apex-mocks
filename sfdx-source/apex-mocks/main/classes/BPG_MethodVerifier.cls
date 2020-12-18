/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 *	This class implements the actual verification.
 *	@group Core
 */
public abstract class BPG_MethodVerifier
{
	/**
	 * Verify a method was called on a mock object.
	 * @param mockInvocation The object holding all the data of the invocation, like the method and arguments and the mock instance.
	 * @param verificationMode The verification mode that holds the setting about how the verification should be performed.
	 */
	public void verifyMethodCall(BPG_InvocationOnMock mockInvocation, BPG_VerificationMode verificationMode)
	{
		validateMode(verificationMode);

		verify(mockinvocation.getMethod(), mockinvocation.getMethodArgValues(), verificationMode);
	}

	/*
	 * Method that actually performs the verify
	 * @param qm The method to be verified.
	 * @param methodArg The arguments of the method that needs to be verified.
	 * @param verificationMode The verification mode that holds the setting about how the verification should be performed.
	 */
	protected abstract void verify(
		BPG_QualifiedMethod qm,
		BPG_MethodArgValues methodArg,
		BPG_VerificationMode verificationMode);

	/*
	 * Method that validates the verification mode used in the verify.
	 * Not all the methods from the BPG_VerificationMode are implemented for the different classes that extends the BPG_MethodVerifier.
	 * The error is thrown at run time, so this method is called in the method that actually performs the verify.
	 * @param verificationMode The verification mode that has to have been verified.
	 * @throws Exception with message for the BPG_VerificationMode not implemented.
	 */
	protected abstract void validateMode(BPG_VerificationMode verificationMode);

	/*
	 * Method that performs the argument capturing.
	 * Captures argument values during verification.
	 * @param matchers The list of matcher with which a method is verified.
	 */
	protected void capture(List<BPG_IMatcher> matchers)
	{
		for(BPG_IMatcher matcher : matchers)
		{
			if( matcher instanceof BPG_ArgumentCaptor.AnyObject )
			{
				((BPG_ArgumentCaptor.AnyObject)matcher).storeArgument();
			}
		}
	}

	protected void throwException(
		BPG_QualifiedMethod qm,
		String inOrder,
		Integer expectedCount,
		String qualifier,
		Integer methodCount,
		String customAssertMessage)
	{
		String assertMessage = 'Wanted but not invoked: ' + qm + '.';

		if(customAssertMessage != null)
		{
			assertMessage = assertMessage + ' ' + customAssertMessage + '.';
		}

		String message = '{0}Expected : {1}{2}, Actual: {3} -- {4}';

		List<String> errorParameters = new List<String>
		{
			inOrder, expectedCount + '', qualifier, methodCount + '', assertMessage
		};

		throw new BPG_ApexMocks.ApexMocksException(String.format(message, errorParameters));
	}
}