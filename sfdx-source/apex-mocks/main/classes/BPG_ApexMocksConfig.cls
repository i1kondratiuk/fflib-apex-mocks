/*
 * Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */
@IsTest
public class BPG_ApexMocksConfig
{
	/**
	 * When false, stubbed behaviour and invocation counts are shared among all test spies.
	 * - See BPG_ApexMocksTest.thatMultipleInstancesCanBeMockedDependently
	 * - This is the default for backwards compatibility.
	 * When true, each test spy instance has its own stubbed behaviour and invocations.
	 * - See BPG_ApexMocksTest.thatMultipleInstancesCanBeMockedIndependently
	 */
	public static Boolean HasIndependentMocks {get; set;}

	static
	{
		HasIndependentMocks = false;
	}
}