/*
 Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
public with sharing class BPG_MethodCountRecorder
{
	/*
	 * Map of method arguments by type name.
	 *
	 * Key: qualifiedMethod
	 * Object: list of method arguments.
	 *
	 * Object: map of count by method call argument.
	 */
	private static Map<BPG_QualifiedMethod, List<BPG_MethodArgValues>> methodArgumentsByTypeName =
		new Map<BPG_QualifiedMethod, List<BPG_MethodArgValues>>();

	private static List<BPG_InvocationOnMock> orderedMethodCalls =
		new List<BPG_InvocationOnMock>();

	/**
	 * Getter for the list of the methods ordered calls.
	 * @return The list of methods called in order.
	 */
	public static List<BPG_InvocationOnMock> getOrderedMethodCalls()
	{
		return orderedMethodCalls;
	}

	/**
	 * Getter for the map of the method's calls with the related arguments.
	 * @return The map of methods called with the arguments.
	 */
	public static Map<BPG_QualifiedMethod, List<BPG_MethodArgValues>> getMethodArgumentsByTypeName()
	{
		return methodArgumentsByTypeName;
	}

	/**
	 * Record a method was called on a mock object.
	 * @param invocation The object holding all the data of the invocation, like the method and arguments and the mock instance.
	 */
	public void recordMethod(BPG_InvocationOnMock invocation)
	{
		List<BPG_MethodArgValues> methodArgs =
			methodArgumentsByTypeName.get(invocation.getMethod());

		if (methodArgs == null)
		{
			methodArgs = new List<BPG_MethodArgValues>();
			methodArgumentsByTypeName.put(invocation.getMethod(), methodArgs);
		}

		methodArgs.add(invocation.getMethodArgValues());

		orderedMethodCalls.add(invocation);
	}
}