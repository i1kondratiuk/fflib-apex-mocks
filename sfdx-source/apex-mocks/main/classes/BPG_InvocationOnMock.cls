/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 *	An invocation on a mock.
 *	A place holder for mock, the method that was called and the arguments that were passed.
 *	@group Core
 */
public with sharing class BPG_InvocationOnMock
{
	private BPG_QualifiedMethod qm;
	private BPG_MethodArgValues methodArg;
	private Object mockInstance;

	/**
	 *	Constructor for the class.
	 *  @param qm The BPG_QualifiedMethod instance to be stored.
	 *  @param args The BPG_MethodArgValues instance to be stored.
	 *  @param mockInstance The mock instance to be stored.
	 */
	public BPG_InvocationOnMock(BPG_QualifiedMethod qm, BPG_MethodArgValues args, Object mockInstance)
	{
		this.qm = qm;
		this.methodArg = args;
		this.mockInstance = mockInstance;
	}

	/**
	 *	Returns the argument at the given index.
	 *  @param index The index of the wanted argument.
	 *  @throws ApexMocksException in case the index is out of range.
	 *  @return The argument at the given index.
	 */
	public Object getArgument(Integer index)
	{
		validateIndex(index);
		return methodArg.argValues[index];
	}

	/**
	 *	Returns the list of arguments passed to the method.
	 *  @return The list of arguments.
	 */
	public List<Object> getArguments()
	{
		return methodArg.argValues;
	}

	/**
	 *	Returns BPG_MethodArgValues instance that represents the arguments passed to the method.
	 *  @return The BPG_MethodArgValues instance that represents the arguments passed to the method.
	 */
	public BPG_MethodArgValues getMethodArgValues()
	{
		return methodArg;
	}

	/**
	 *	Returns the BPG_QualifiedMethod instance that represent the fully qualified method called within the invocation.
	 *	@return The method stored in the invocation.
	 */
	public BPG_QualifiedMethod getMethod()
	{
		return qm;
	}

	/**
	 *	Returns the mock object on which the invocation occurs.
	 *	@return The mock object on which the invocation occurs.
	 */
	public Object getMock()
	{
		return mockInstance;
	}

	private void validateIndex(Integer index)
	{
		if(index < 0 || index >= methodArg.argValues.size())
		{
			throw new BPG_ApexMocks.ApexMocksException('Invalid index, must be greater or equal to zero and less of ' + methodArg.argValues.size()+'.');
		}
	}
}