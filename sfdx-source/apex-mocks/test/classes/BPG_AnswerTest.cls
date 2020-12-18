/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @nodoc
 */
@isTest
private class BPG_AnswerTest
{

	private static BPG_InvocationOnMock actualInvocation = null;

	@isTest
	static void thatAnswersWithException()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.ExceptionForAnswer());
		mocks.stopStubbing();

		// When
		try
		{
			mockList.get2(0, 'Hi hi Hello Hi hi');
			System.assert(false, 'an exception is expected to be thrown on the answer execution');
		}
		catch(BPG_ApexMocks.ApexMocksException ansExpt)
		{
			String expectedMessage = 'an error occurs on the execution of the answer';
			// Then
			System.assertEquals(expectedMessage, ansExpt.getMessage(), 'the message from the answer is not as expected');
		}
	}

	@isTest
	static void thatStoresMethodIntoInvocationOnMock()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.BasicAnswer());
		mocks.stopStubbing();

		// When
		mockList.get2(0, 'Hi hi Hello Hi hi');

		// Then

		Object methodCalled = actualInvocation.getMethod();
		System.assert(methodCalled instanceof BPG_QualifiedMethod, 'the object returned is not a method as expected');

		String expectedMethodSignature = BPG_MyList.getStubClassName() + '.get2(Integer, String)';
		System.assertEquals(expectedMethodSignature, ((BPG_QualifiedMethod)methodCalled).toString(), ' the method is no the one expected');
	}

	@isTest
	static void thatAnswerOnlyForTheMethodStubbedWithAnswer()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get(3)).thenReturn('ted');
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.BasicAnswer());
		mocks.stopStubbing();

		// When
		mockList.add('one');
		String noAnswered = mockList.get(3);
		mockList.get2(0, 'Hi hi Hello Hi hi');

		// Then
		Object methodCalled = actualInvocation.getMethod();
		System.assert(methodCalled instanceof BPG_QualifiedMethod, 'the object returned is not a method as expected');

		String expectedMethodSignature = BPG_MyList.getStubClassName() + '.get2(Integer, String)';
		System.assertEquals(expectedMethodSignature, ((BPG_QualifiedMethod)methodCalled).toString(), ' the method is no the one expected');

		System.assertEquals('ted', noAnswered, 'the get method should have returned the stubbed string');
	}

	@isTest
	static void thatMultipleAnswersAreHandled()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get(3)).thenAnswer(new BPG_AnswerTest.FirstAnswer());
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.SecondAnswer());
		mocks.stopStubbing();

		// When
		mockList.add('one');
		String answer1 = mockList.get(3);
		String answer2 = mockList.get2(0, 'Hi hi Hello Hi hi');

		System.assertEquals('this is the first answer', answer1, 'the answer wasnt the one expected');
		System.assertEquals('and this is the second one', answer2, 'the answer wasnt the one expected');
	}

	@isTest
	static void thatStoresMockInstanceIntoInvocationOnMock()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.BasicAnswer());
		mocks.stopStubbing();

		// When
		String mockCalled = mockList.get2(0, 'Hi hi Hello Hi hi');

		// Then
		System.assert(actualInvocation.getMock() instanceof BPG_MyList.IList, 'the object returned is not a mock instance as expected');
		System.assertEquals(mockList, actualInvocation.getMock(), 'the mock returned should be the mockList used in the stubbing');
	}

	@isTest
	static void thatMethodsParametersAreAccessible()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.ProcessArgumentAnswer());
		mocks.stopStubbing();

		// When
		String actualValue = mockList.get2(0, 'Hi hi Hello Hi hi');

		// Then
		System.assertEquals('Bye hi Hello Bye hi', actualValue, 'the answer is not correct');
	}

	@isTest
	static void thatAnswerOnlyForTheStubbedParameter()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.ProcessArgumentAnswer());
		mocks.stopStubbing();

		// When
		String actualValue1 = mockList.get2(0, 'some string for my method');
		String actualValue2 = mockList.get2(0, 'Hi hi Hello Hi hi');
		String actualValue3 = mockList.get2(0, 'another string for the same method');

		// Then
		System.assertEquals('Bye hi Hello Bye hi', actualValue2, 'the answer is not correct');
		System.assertEquals(null, actualValue1, 'the answer is not correct');
		System.assertEquals(null, actualValue3, 'the answer is not correct');
	}

	@isTest
	static void thatMethodsParametersAreAccessibleWhenCalledWithMatchers()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(BPG_Match.anyInteger(), BPG_Match.anyString())).thenAnswer(new BPG_AnswerTest.ProcessArgumentAnswer());
		mocks.stopStubbing();

		// When
		String actualValue = mockList.get2(0, 'Hi hi Hello Hi hi');

		// Then
		System.assertEquals('Bye hi Hello Bye hi', actualValue, 'the answer is not correct');
	}

	@isTest
	static void thatExceptionIsThrownWhenAccessOutOfIndexArgument()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.ExceptionForArgumentsOutOfBound());
		mocks.stopStubbing();

		// When
		String actualValue = mockList.get2(0, 'Hi hi Hello Hi hi');
	}

	@isTest
	static void thatExceptionIsThrownWhenAccessNegativeIndexArgument()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get2(0, 'Hi hi Hello Hi hi')).thenAnswer(new BPG_AnswerTest.ExceptionForNegativeArgumentIndex());
		mocks.stopStubbing();

		// When
		String actualValue = mockList.get2(0, 'Hi hi Hello Hi hi');
	}

	@isTest
	static void thatArgumentListEmptyForMethodWithNoArgument()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.isEmpty()).thenAnswer(new BPG_AnswerTest.ArgumentListEmptyForMethodWithNoArgument());
		mocks.stopStubbing();

		// When
		Boolean actualValue = mockList.isEmpty();
	}

	@isTest
	static void thatAnswerToVoidMethod()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		((BPG_MyList) mocks.doAnswer(new BPG_AnswerTest.BasicAnswer(), mockList)).addMore('Hi hi Hello Hi hi');
		mocks.stopStubbing();

		// When
		mockList.addMore('Hi hi Hello Hi hi');

		// Then
		Object methodCalled = actualInvocation.getMethod();
		System.assert(methodCalled instanceof BPG_QualifiedMethod, 'the object returned is not a method as expected');

		String expectedMethodSignature = BPG_MyList.getStubClassName() + '.addMore(String)';
		System.assertEquals(expectedMethodSignature, ((BPG_QualifiedMethod)methodCalled).toString(), 'Unexpected method name: ' + methodCalled);
	}

	@isTest
	static void thatAnswerToVoidAndNotVoidMethods()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		mocks.startStubbing();
		((BPG_MyList) mocks.doAnswer(new BPG_AnswerTest.FirstAnswer(), mockList)).get(3);
		((BPG_MyList) mocks.doAnswer(new BPG_AnswerTest.BasicAnswer(), mockList)).addMore('Hi hi Hello Hi hi');
		((BPG_MyList) mocks.doAnswer(new BPG_AnswerTest.SecondAnswer(), mockList)).get2(4, 'Hi hi Hello Hi hi');
		mocks.stopStubbing();

		// When
		String answer1 = mockList.get(3);
		String answer2 = mockList.get2(4, 'Hi hi Hello Hi hi');
		mockList.addMore('Hi hi Hello Hi hi');

		// Then
		Object methodCalled = actualInvocation.getMethod();
		System.assert(methodCalled instanceof BPG_QualifiedMethod, 'the object returned is not a method as expected');

		String expectedMethodSignature = BPG_MyList.getStubClassName() + '.addMore(String)';
		System.assertEquals(expectedMethodSignature, ((BPG_QualifiedMethod)methodCalled).toString(),
			'the last method called should be the addMore, so should be the last to set the actualInvocation variable.');

		System.assertEquals('this is the first answer', answer1, 'the answer was not the one expected');
		System.assertEquals('and this is the second one', answer2, 'the answer was not the one expected');
	}

	@isTest
	static void thatAnswerToDifferentVoidMethods()
	{
		// Given
		BPG_ApexMocks mocks = new BPG_ApexMocks();
		BPG_MyList mockList = (BPG_MyList)mocks.mock(BPG_MyList.class);

		BPG_AnswerTest.FirstAnswer answer1 = new BPG_AnswerTest.FirstAnswer();
		BPG_AnswerTest.SecondAnswer answer2 = new BPG_AnswerTest.SecondAnswer();

		System.assertEquals(null, answer1.getMessage(), 'the answer message should be null at this stage');
		System.assertEquals(null, answer2.getMessage(), 'the answer message should be null at this stage');

		mocks.startStubbing();
		((BPG_MyList) mocks.doAnswer(answer1, mockList)).addMore('Hi hi Hello Hi hi');
		((BPG_MyList) mocks.doAnswer(answer2, mockList)).add('Hello');
		mocks.stopStubbing();

		// When
		mockList.addMore('Hi hi Hello Hi hi');
		mockList.add('Hello');

		// Then
		System.assertEquals('this is the first answer', answer1.getMessage(), 'the answer was not the one expected');
		System.assertEquals('and this is the second one', answer2.getMessage(), 'the answer was not the one expected');
	}

	//Answers

	public class BasicAnswer implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;
			return null;
		}
	}

	public class ExceptionForAnswer implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			throw new BPG_ApexMocks.ApexMocksException('an error occurs on the execution of the answer');
			return null;
		}
	}

	public class ExceptionForArgumentsOutOfBound implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			try
			{
				Object noExistingObj = invocation.getArgument(2);
				System.assert(false, 'an exception was expected because the argument in the method are only 2');
			}
			catch(BPG_ApexMocks.ApexMocksException exp)
			{
				String expectedMessage = 'Invalid index, must be greater or equal to zero and less of 2.';
				String actualMessage = exp.getMessage();
				System.assertEquals(expectedMessage, actualMessage, 'the message return by the exception is not as expected');
			}
			return null;
		}
	}

	public class ExceptionForNegativeArgumentIndex implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			try
			{
				Object noExistingObj = invocation.getArgument(-1);
				System.assert(false, 'an exception was expected because the argument index cannot be negative');
			}
			catch(BPG_ApexMocks.ApexMocksException exp)
			{
				String expectedMessage = 'Invalid index, must be greater or equal to zero and less of 2.';
				String actualMessage = exp.getMessage();
				System.assertEquals(expectedMessage, actualMessage, 'the message return by the exception is not as expected');
			}
			return null;
		}
	}

	public class ArgumentListEmptyForMethodWithNoArgument implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			List<Object> emptyList = invocation.getArguments();

			System.assertEquals(0, emptyList.size(), 'the argument list from a method without arguments should be empty');

			return null;
		}
	}

	public class FirstAnswer implements BPG_Answer
	{
		private String answerMessage;

		public String getMessage()
		{
			return this.answerMessage;
		}

		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			this.answerMessage = 'this is the first answer';

			return answerMessage;
		}
	}

	public class SecondAnswer implements BPG_Answer
	{
		private String answerMessage;

		public String getMessage()
		{
			return this.answerMessage;
		}

		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			this.answerMessage = 'and this is the second one';

			return answerMessage;
		}
	}

	public class ProcessArgumentAnswer implements BPG_Answer
	{
		public Object answer(BPG_InvocationOnMock invocation)
		{
			actualInvocation = invocation;

			String argument = (String) invocation.getArgument(1);
			System.assertNotEquals(null, argument, ' the argument should have some value');
			argument = argument.replace('Hi', 'Bye');
			return argument;
		}
	}
}