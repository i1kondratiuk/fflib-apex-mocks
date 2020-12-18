/**
 * Copyright (c) 2014-2016, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
@isTest
public with sharing class BPG_MatchTest
{
	@isTest
	private static void whenMatchesAllArgsWithOneMatchReturnsTrue()
	{
		//Given
		BPG_MethodArgValues argValues = new BPG_MethodArgValues(new List<Object>{ null });
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{ new AlwaysMatch() };
		
		//When
		Boolean match = BPG_Match.matchesAllArgs(argValues, targetMatchers);

		//Then
		System.assert(match);
	}
	
	@isTest
	private static void whenMatchesAllArgsWithManyMatchesReturnsTrue()
	{
		//Given
		BPG_MethodArgValues argValues = new BPG_MethodArgValues(new List<Object>{
			null,
			null,
			null,
			null
		});
		
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{
			new AlwaysMatch(),
			new AlwaysMatch(),
			new AlwaysMatch(),
			new AlwaysMatch()
		};
		
		//When
		Boolean match = BPG_Match.matchesAllArgs(argValues, targetMatchers);

		//Then
		System.assert(match);
	}
	
	@isTest
	private static void whenMatchesAllArgsWithOneMismatchReturnsFalse()
	{
		//Given
		BPG_MethodArgValues argValues = new BPG_MethodArgValues(new List<Object>{ null });
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{ new NeverMatch() };
		
		//When
		Boolean match = BPG_Match.matchesAllArgs(argValues, targetMatchers);

		//Then
		System.assert(!match);
	}
	
	@isTest
	private static void whenMatchesAllArgsWithManyMismatchesReturnsFalse()
	{
		//Given
		BPG_MethodArgValues argValues = new BPG_MethodArgValues(new List<Object>{
			null,
			null,
			null,
			null
		});
		
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{
			new NeverMatch(),
			new NeverMatch(),
			new NeverMatch(),
			new NeverMatch()
		};
		
		//When
		Boolean match = BPG_Match.matchesAllArgs(argValues, targetMatchers);

		//Then
		System.assert(!match);
	}
	
	@isTest
	private static void whenMatchesAllArgsWithMatchesAndMismatchesReturnsFalse()
	{
		//Given
		BPG_MethodArgValues argValues = new BPG_MethodArgValues(new List<Object>{
			null,
			null,
			null,
			null
		});
		
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{
			new AlwaysMatch(),
			new AlwaysMatch(),
			new NeverMatch(),
			new AlwaysMatch()
		};
		
		//When
		Boolean match = BPG_Match.matchesAllArgs(argValues, targetMatchers);

		//Then
		System.assert(!match);
	}
	
	@isTest
	private static void whenMatchesAllArgsWithNullMethodArgsThrowsException()
	{
		//Given
		BPG_MethodArgValues methodArg = null;
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{ new AlwaysMatch() };
		
		//When
		try
		{
			BPG_Match.matchesAllArgs(methodArg, targetMatchers);
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			System.assertEquals('MethodArgs cannot be null', e.getMessage());
		}
	}
	
	@isTest
	private static void whenMatchesAllArgsWithNullMethodArgsArgValuesThrowsException()
	{
		//Given
		BPG_MethodArgValues methodArg = new BPG_MethodArgValues(null);
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{ new AlwaysMatch() };
		
		//When
		try
		{
			BPG_Match.matchesAllArgs(methodArg, targetMatchers);
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			System.assertEquals('MethodArgs.argValues cannot be null', e.getMessage());
		}
	}
	
	@isTest
	private static void whenMatchesAllArgsWithNullMatchersThrowsException()
	{
		//Given
		BPG_MethodArgValues methodArg = new BPG_MethodArgValues(new List<Object>{ 'Test' });
		List<BPG_IMatcher> targetMatchers = null;
		
		//When
		try
		{
			BPG_Match.matchesAllArgs(methodArg, targetMatchers);
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			System.assertEquals('Matchers cannot be null', e.getMessage());
		}
	}
	
	@isTest
	private static void whenMatchesAllArgsWithDifferentSizeArgValuesAndMatchersThrowsException()
	{
		//Given
		BPG_MethodArgValues methodArg = new BPG_MethodArgValues(new List<Object>{ 'Test' });
		List<BPG_IMatcher> targetMatchers = new List<BPG_IMatcher>{ new AlwaysMatch(), new AlwaysMatch() };
		
		//When
		try
		{
			BPG_Match.matchesAllArgs(methodArg, targetMatchers);
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			String expectedMessage = 'MethodArgs and matchers must have the same count'
				+ ', MethodArgs: (' + methodArg.argValues.size() + ') ' + methodArg.argValues
				+ ', Matchers: (' + targetMatchers.size() + ') ' + targetMatchers;

			System.assertEquals(expectedMessage, e.getMessage());
		}
	}
	
	@isTest
	private static void whenMatchesWithOneMatcherSetsMatchingToTrue()
	{
		//Given
		BPG_IMatcher matcher = new AlwaysMatch();
		
		//When
		BPG_Match.matches(matcher);
		
		//Then
		System.assert(BPG_Match.Matching);
	}
	
	@isTest
	private static void whenMatchesWithOneMatcherRegistersMatcher()
	{
		//Given
		BPG_IMatcher matcher = new AlwaysMatch();
		
		//When
		BPG_Match.matches(matcher);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(matcher === registeredMatchers[0]);
	}
	
	@isTest
	private static void whenMatchesWithOneMatcherReturnsNull()
	{
		//Given
		BPG_IMatcher matcher = new AlwaysMatch();
		
		//When
		Object retval = BPG_Match.matches(matcher);
		
		//Then
		System.assertEquals(null, retval);
	}

	@isTest
	private static void allOfWithNoArgsThrowsException()
	{
		//Given/When
		try
		{
			Object x = BPG_Match.allOf((List<Object>)null);
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			System.assertEquals('Must register matchers to combine', e.getMessage());
		}
	}

	@isTest
	private static void allOfWithEmptyArgsThrowsException()
	{
		//Given/When
		try
		{
			Object x = BPG_Match.allOf(new List<Object>{});
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			System.assertEquals('Must register matchers to combine', e.getMessage());
		}
	}

	@isTest
	private static void allOfWithoutRegisteringInnerMatchersThrowsException()
	{
		//Given/When
		try
		{
			//Should be using BPG_Match.allOf(new List<Object>{ BPG_Match.myMatcher('Hello') })
			//to register the inner matcher.
			Object x = BPG_Match.allOf(new List<Object>{ 'Hello' });
			System.assert(false, 'Expected exception');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			//Then
			String expectedMessage = 'Error reclaiming inner matchers for combined matcher. '
				+ 'Wanted 1 matchers but only got ' + new List<BPG_IMatcher>();
			System.assertEquals(expectedMessage, e.getMessage());
		}
	}
	
	@isTest
	private static void allOfWith2ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.allOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void allOfWith3ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.allOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void allOfWith4ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.allOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'), BPG_Match.eq('hello4'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void allOfWithListArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.allOf(new List<Object>{ BPG_Match.eq('hello') });
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void anyOfWith2ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.anyOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void anyOfWith3ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.anyOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void anyOfWith4ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.anyOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'), BPG_Match.eq('hello4'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void anyOfWithListArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.anyOf(new List<Object>{ BPG_Match.eq('hello') });
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void isNotRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.isNot(BPG_Match.eq('hello1'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void noneOfWith2ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.noneOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void noneOfWith3ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.noneOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void noneOfWith4ArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.noneOf(BPG_Match.eq('hello1'), BPG_Match.eq('hello2'), BPG_Match.eq('hello3'), BPG_Match.eq('hello4'));
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void noneOfWithListArgsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.noneOf(new List<Object>{ BPG_Match.eq('hello') });
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Combined);
	}

	@isTest
	private static void eqRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eq('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqBooleanRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqBoolean(true);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqDateRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqDate(Date.today());
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqDatetimeRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqDatetime(System.now());
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqDecimalRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqDecimal(123);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqDoubleRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqDouble(123);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqIdRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqId('001000000000001AAA');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqIntegerRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqInteger(123);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqListRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqList(new List<String>{ 'hello' });
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqLongRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqLong(123);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqSObjectFieldRegistersCorrectMatcherType()
	{
		//Given/When
		Schema.SObjectField f = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Id');
		Object x = BPG_Match.eqSObjectField(f);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqSObjectTypeRegistersCorrectMatcherType()
	{
		//Given/When
		Schema.SObjectType ot = Schema.getGlobalDescribe().get('Account');
		Object x = BPG_Match.eqSObjectType(ot);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	public static void eqStringRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.eqString('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.Eq);
	}

	@isTest
	private static void refEqRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.refEq('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.RefEq);
	}

	@isTest
	private static void anyBooleanRegistersCorrectMatcherType()
	{
		//Given/When
		Boolean x = BPG_Match.anyBoolean();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyBoolean);
	}

	@isTest
	private static void anyDateRegistersCorrectMatcherType()
	{
		//Given/When
		Date x = BPG_Match.anyDate();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyDate);
	}

	@isTest
	private static void anyDatetimeRegistersCorrectMatcherType()
	{
		//Given/When
		Datetime x = BPG_Match.anyDatetime();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyDatetime);
	}

	@isTest
	private static void anyDecimalRegistersCorrectMatcherType()
	{
		//Given/When
		Decimal x = BPG_Match.anyDecimal();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyDecimal);
	}

	@isTest
	private static void anyDoubleRegistersCorrectMatcherType()
	{
		//Given/When
		Double x = BPG_Match.anyDouble();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyDouble);
	}

	@isTest
	private static void anyFieldSetRegistersCorrectMatcherType()
	{
		//Given/When
		Schema.FieldSet x = BPG_Match.anyFieldSet();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyFieldSet);
	}

	@isTest
	private static void anyIdRegistersCorrectMatcherType()
	{
		//Given/When
		Id x = BPG_Match.anyId();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyId);
	}

	@isTest
	private static void anyIntegerRegistersCorrectMatcherType()
	{
		//Given/When
		Integer x = BPG_Match.anyInteger();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyInteger);
	}

	@isTest
	private static void anyListRegistersCorrectMatcherType()
	{
		//Given/When
		List<Object> x = BPG_Match.anyList();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyList);
	}

	@isTest
	private static void anyLongRegistersCorrectMatcherType()
	{
		//Given/When
		Long x = BPG_Match.anyLong();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyLong);
	}

	@isTest
	private static void anyObjectRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.anyObject();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyObject);
	}

	@isTest
	private static void anyStringRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.anyString();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnyString);
	}

	@isTest
	private static void anySObjectRegistersCorrectMatcherType()
	{
		//Given/When
		SObject x = BPG_Match.anySObject();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnySObject);
	}

	@isTest
	private static void anySObjectFieldRegistersCorrectMatcherType()
	{
		//Given/When
		SObjectField x = BPG_Match.anySObjectField();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnySObjectField);
	}

	@isTest
	private static void anySObjectTypeRegistersCorrectMatcherType()
	{
		//Given/When
		SObjectType x = BPG_Match.anySObjectType();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.AnySObjectType);
	}

	@isTest
	private static void dateAfterRegistersCorrectMatcherType()
	{
		//Given/When
		Date x = BPG_Match.dateAfter(Date.today());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeAfter);
	}

	@isTest
	private static void dateBeforeRegistersCorrectMatcherType()
	{
		//Given/When
		Date x = BPG_Match.dateBefore(Date.today());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeBefore);
	}

	@isTest
	private static void dateBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Date x = BPG_Match.dateBetween(Date.today(), Date.today());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeBetween);
	}

	@isTest
	private static void datetimeAfterRegistersCorrectMatcherType()
	{
		//Given/When
		Datetime x = BPG_Match.datetimeAfter(System.now());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeAfter);
	}

	@isTest
	private static void datetimeBeforeRegistersCorrectMatcherType()
	{
		//Given/When
		Datetime x = BPG_Match.datetimeBefore(System.now());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeBefore);
	}

	@isTest
	private static void datetimeBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Datetime x = BPG_Match.datetimeBetween(System.now(), System.now());

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DatetimeBetween);
	}

	@isTest
	private static void decimalBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Decimal x = BPG_Match.decimalBetween(0, 10);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalBetween);
	}

	@isTest
	private static void decimalLessThanRegistersCorrectMatcherType()
	{
		//Given/When
		Decimal x = BPG_Match.decimalLessThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalLessThan);
	}

	@isTest
	private static void decimalMoreThanRegistersCorrectMatcherType()
	{
		//Given/When
		Decimal x = BPG_Match.decimalMoreThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalMoreThan);
	}

	@isTest
	private static void doubleBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Double x = BPG_Match.doubleBetween(0, 10);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalBetween);
	}

	@isTest
	private static void doubleLessThanRegistersCorrectMatcherType()
	{
		//Given/When
		Double x = BPG_Match.doubleLessThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalLessThan);
	}

	@isTest
	private static void doubleMoreThanRegistersCorrectMatcherType()
	{
		//Given/When
		Double x = BPG_Match.doubleMoreThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalMoreThan);
	}

	@isTest
	private static void fieldSetEquivalentWithNullFieldSetThrowsException()
	{
		try
		{
			BPG_Match.fieldSetEquivalentTo(null);
			System.assert(false, 'ExpectedException');
		}
		catch (BPG_ApexMocks.ApexMocksException e)
		{
			System.assertEquals('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void fieldSetEquivalentToRegistersCorrectMatcherType()
	{
		Schema.FieldSet anyFieldSet = BPG_ApexMocksUtilsTest.findAnyFieldSet();
		if (anyFieldSet == null)
		{
			return;
		}

		//Given/When
		Schema.FieldSet x = BPG_Match.fieldSetEquivalentTo(anyFieldSet);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.FieldSetEquivalentTo);
	}

	@isTest
	private static void integerBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Integer x = BPG_Match.integerBetween(0, 10);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalBetween);
	}

	@isTest
	private static void integerLessThanRegistersCorrectMatcherType()
	{
		//Given/When
		Integer x = BPG_Match.integerLessThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalLessThan);
	}

	@isTest
	private static void integerMoreThanRegistersCorrectMatcherType()
	{
		//Given/When
		Integer x = BPG_Match.integerMoreThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalMoreThan);
	}

	@isTest
	private static void isNotNullRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.isNotNull();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.IsNotNull);
	}

	@isTest
	private static void isNullRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.isNull();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.IsNull);
	}

	@isTest
	private static void listContainsRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.listContains('fred');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.ListContains);
	}

	@isTest
	private static void listIsEmptyRegistersCorrectMatcherType()
	{
		//Given/When
		Object x = BPG_Match.listIsEmpty();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.ListIsEmpty);
	}

	@isTest
	private static void longBetweenRegistersCorrectMatcherType()
	{
		//Given/When
		Long x = BPG_Match.longBetween(0, 10);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalBetween);
	}

	@isTest
	private static void longLessThanRegistersCorrectMatcherType()
	{
		//Given/When
		Long x = BPG_Match.longLessThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalLessThan);
	}

	@isTest
	private static void longMoreThanRegistersCorrectMatcherType()
	{
		//Given/When
		Long x = BPG_Match.longMoreThan(0);
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.DecimalMoreThan);
	}

	@isTest
	private static void sObjectOfTypeRegistersCorrectMatcherType()
	{
		//Given
		Schema.SObjectType ot = Schema.getGlobalDescribe().get('Account');
		if (ot == null)
		{
			return;
		}

		//When
		SObject x = BPG_Match.sObjectOfType(ot);

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectOfType);
	}

	@isTest
	private static void sObjectWithRegistersCorrectMatcherType()
	{
		//Given
		Schema.SObjectType ot = Schema.getGlobalDescribe().get('Account');
		if (ot == null)
		{
			return;
		}

		Schema.SObjectField f = ot.getDescribe().fields.getMap().get('Id');

		//When
		SObject x = BPG_Match.sObjectWith(new Map<Schema.SObjectField, Object>{ f=>null });

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectWith);
	}

    @isTest
	private static void sObjectsWithRegistersCorrectMatcherType()
	{
		//Given
		Schema.SObjectType ot = Schema.getGlobalDescribe().get('Account');
		if (ot == null)
		{
			return;
		}

		Schema.SObjectField f = ot.getDescribe().fields.getMap().get('Id');

		//When
		SObject[] x = BPG_Match.sObjectsWith(new list<Map<Schema.SObjectField, Object>>{ 
            new map<Schema.SObjectField,Object> {f=>null}
        	});

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectsWith);
	}

    @isTest
	private static void sObjectsWithMatchInOrderRegistersCorrectMatcherType()
	{
		//Given
		Schema.SObjectType ot = Schema.getGlobalDescribe().get('Account');
		if (ot == null)
		{
			return;
		}

		Schema.SObjectField f = ot.getDescribe().fields.getMap().get('Id');

		//When
		SObject[] x = BPG_Match.sObjectsWith(new list<Map<Schema.SObjectField, Object>>{ 
            new map<Schema.SObjectField,Object> {f=>null}
        	}, false);

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectsWith,registeredMatchers);
	}
    
	@isTest
	private static void sObjectWithIdRegistersCorrectMatcherType()
	{
		//Given/When
		SObject x = BPG_Match.sObjectWithId('001000000000001AAA');

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectWithId);
	}

	@isTest
	private static void sObjectWithNameRegistersCorrectMatcherType()
	{
		//Given/When
		SObject x = BPG_Match.sObjectWithName('hello');

		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.SObjectWithName);
	}

	@isTest
	private static void stringContainsRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringContains('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringContains);
	}

	@isTest
	private static void stringEndsWithRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringEndsWith('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringEndsWith);
	}

	@isTest
	private static void stringIsBlankRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringIsBlank();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringIsBlank);
	}

	@isTest
	private static void stringIsNotBlankRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringIsNotBlank();
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringIsNotBlank);
	}

	@isTest
	private static void stringMatchesRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringMatches('[a-z]*');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringMatches);
	}

	@isTest
	private static void stringStartsWithRegistersCorrectMatcherType()
	{
		//Given/When
		String x = BPG_Match.stringStartsWith('hello');
		
		//Then
		List<BPG_IMatcher> registeredMatchers = BPG_Match.getAndClearMatchers(1);
		System.assertNotEquals(null, registeredMatchers);
		System.assertEquals(1, registeredMatchers.size());
		System.assert(registeredMatchers[0] instanceof BPG_MatcherDefinitions.StringStartsWith);
	}

	private class AlwaysMatch implements BPG_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return true;
		}
	}
	
	private class NeverMatch implements BPG_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return false;
		}
	}
}