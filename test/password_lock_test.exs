defmodule PasswordLockTest do
  use ExUnit.Case
  doctest PasswordLock
  @doc """
  In order to test server callbacks we need the pid of password_lock.ex .
  So, we are setting here . {:ok,server_pid} = PasswordLock.start_link("foo")
  Here, we are calling the start_link function which will return the {:ok,pid}.

  We are saving our pid in the variable server_pid.

  The setup terms can be accessed in the unit test cases.
  """

  setup  do
    {:ok, server_pid} = PasswordLock.start_link("foo")
    {:ok, server: server_pid}
  end

  @doc """
  The line test "unlock success test", %{server: pid} this describes your unit test case and second parameter here is a map.
  We are pattern matching here.
  So, the pid will be the process id for password_lock.ex GenServer and
  the code line assert :ok == PasswordLock.unlock(pid,"foo") will check for the assertiveness
  of the function call return PasswordLock.unlock(pid,"foo")
  """
  test "unlock success test", %{server: pid} do
    assert :ok == PasswordLock.unlock(pid, "foo")
  end

  test "unlock failure  test", %{server: pid} do
    assert {:error,"Wrong password"} == PasswordLock.unlock(pid,"bar")
  end

  test "reset failure error" ,%{server: pid} do
    assert {:error,"wrongpassword"} == PasswordLock.reset(pid,{"hello","bar"})
  end

  test "reset success test" ,%{server: pid} do
    assert :ok == PasswordLock.reset(pid,{"foo","bar"})
  end
end
