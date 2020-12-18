/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 *	'Classic' invocation verifier - checks that a method was called with the given arguments the expected number of times.
 *	The order of method calls is not important.
 *	@group Core
 */
public class BPG_AnyOrder extends BPG_MethodVerifier
{
	/*
	 * Verifies a method was invoked the expected number of times, with the expected arguments.
	 * @param qualifiedMethod The method to be verified.
	 * @param methodArg The arguments of the method that needs to be verified.
	 * @param verificationMode The verification mode that holds the setting about how the verification should be performed.
	 */
	protected override void verify(
		BPG_QualifiedMethod qm,
		BPG_MethodArgValues methodArg,
		BPG_VerificationMode verificationMode)
	{
		Integer methodCount = getMethodCount(qm, methodArg);

		String qualifier = '';
		Integer expectedCount = null;

		if((verificationMode.VerifyMin == verificationMode.VerifyMax) && methodCount != verificationMode.VerifyMin)
		{
			expectedCount = verificationMode.VerifyMin;
		}
		else if (verificationMode.VerifyMin != null && verificationMode.VerifyMin > methodCount)
		{
			expectedCount = verificationMode.VerifyMin;
			qualifier = ' or more times';
		}
		else if (verificationMode.VerifyMax != null && verificationMode.VerifyMax < methodCount)
		{
			expectedCount = verificationMode.VerifyMax;
			qualifier = ' or fewer times';
		}

		if (expectedCount != null)
		{
			throwException(qm, '', expectedCount, qualifier, methodCount, verificationMode.CustomAssertMessage);
		}
	}

	private Integer getMethodCount(BPG_QualifiedMethod qm, BPG_MethodArgValues methodArg)
	{
		List<BPG_IMatcher> matchers = BPG_Match.Matching ? BPG_Match.getAndClearMatchers(methodArg.argValues.size()) : null;
		Integer retval = 0;

		List<BPG_MethodArgValues> methodArgs =
			BPG_MethodCountRecorder.getMethodArgumentsByTypeName().get(qm);

		if (methodArgs != null)
		{
			if (matchers != null)
			{
				for (BPG_MethodArgValues args : methodArgs)
				{
					if (BPG_Match.matchesAllArgs(args, matchers))
					{
						capture(matchers);

						retval ++;
					}
				}
			}
			else
			{
				return countCalls(methodArgs, methodArg);
			}
		}

		return retval;
	}

	private Integer countCalls(List<BPG_MethodArgValues> methodArgs, BPG_MethodArgValues methodArg)
	{
		Integer count = 0;

		for(BPG_MethodArgValues arg: methodArgs)
		{
			if( arg == methodArg) count++;
		}

		return count;
	}

	/*
	 * Method that validate the verification mode used in the verify.
	 * Not all the methods from the BPG_VerificationMode are implemented for the different classes that extends the BPG_MethodVerifier.
	 * The error is thrown at run time, so this method is called in the method that actually performs the verify.
	 * @param verificationMode The verification mode that have to been verified.
	 * @throws Exception with message for the BPG_VerificationMode not implemented.
	 */
	protected override void validateMode(BPG_VerificationMode verificationMode)
	{
		if(verificationMode.Method == BPG_VerificationMode.ModeName.CALLS)
		{
			throw new BPG_ApexMocks.ApexMocksException(
				'The calls() method is available only in the InOrder Verification.');
		}
	}
}