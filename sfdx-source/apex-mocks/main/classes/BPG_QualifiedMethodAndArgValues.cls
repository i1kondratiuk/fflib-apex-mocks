/*
 Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
public with sharing class BPG_QualifiedMethodAndArgValues
{
	private final BPG_QualifiedMethod qm;
	private final BPG_MethodArgValues args;
	private final Object mockInstance;

	public BPG_QualifiedMethodAndArgValues(BPG_QualifiedMethod qm, BPG_MethodArgValues args, Object mockInstance)
	{
		this.qm = qm;
		this.args = args;
		this.mockInstance = mockInstance;
	}

	public BPG_QualifiedMethod getQualifiedMethod()
	{
		return qm;
	}

	public BPG_MethodArgValues getMethodArgValues()
	{
		return args;
	}

	public Object getMockInstance()
	{
		return mockInstance;
	}

	public override String toString()
	{
		return qm + ' with args: [' + String.join(args.argValues, '],[') + ']';
	}
}