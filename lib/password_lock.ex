defmodule PasswordLock do
  @doc """
  The GenServer is a behavior module that will force you to implement certain definitions
  inside your module once add a line use the GenServer module.
  That means, you have to add few functions which act as your server callbacks to the client.
  It will just abstract the client server relation.
  It means your module should hold the standard set of definitions/functions.
  """
  use GenServer
  @doc """
  CLIENT API
  """

  # Initiate with the given password.

  def start_link(password) do
    # The line above returns a tuple as {:ok, pid} .
    # Now, the client can do requests using the process identifier pid.
    # The GenServer.start_link(module(), any(), [option()]) will trigger a callback to init function fro mthe servier side.

    GenServer.start_link(__MODULE__, password, [])
  end

  @doc """
  Unlocks the given password
  This unlock definition takes two parameters server_pid which is used to make the server callbacks
  and password to unlock the password.
  The unlock logic is to match password with server password.
  """
  def unlock(server_pid, password) do
    # GenServer.call this actually calling the server callback function handle_call
    # which we will define them in server API section.
    # To make server requests we require pid
    # A callback, matching the message pattern {:unlock, password} will be executed.

    GenServer.call(server_pid, {:unlock, password})
  end

  @doc """
  resets the given Password
  This reset definition also takes two parameters server_pid and the second parameter is a tuple of old and new passwords.
  The reset logic is to update the server password if old password is same as server password before.
  """
  def reset(server_pid, {old_password, new_password}) do
    GenServer.call(server_pid, {:reset, {old_password, new_password}})
  end

  @doc """
  SERVER API
  """
  @doc """
  This init definition will let you initiate the state of your GenServer module
  which will be passed as a last parameter in the every callback definition in the server.
  This function is triggered when you make a call to GenServer.start_link function .
  """
  def init(password) do
    # init function should return a tuple.
    # For an example {:ok, initial_server_state::t()}

    {:ok, [password]} # Here state is saved as a list with the given password.
  end

  @doc """
  SERVER callbacks
  The callbacks come in three flavors. They are, as follows; handle_call handle_cast handle_info.
  """

  @doc """
  handle_call - Synchronous call, i.e wait for the server response here.

  handle_cast - Asynchronous call, i.e no need to wait for the server to respond , unlike handle_call
  """

  @doc """
  _from self describes where this message has come from
  passwords states current state of the GenServer.

  If that is updated in any one of the calls will gets affected in other calls too.
  It means, at the time of initiation, we have set the given password as the initial state of our GenServer
  which will be passed passed to every server callback.

  Our logic is simple.
  We are checking whether the given password is inside the state or not.
  If true then return :ok else return {:error, "wrongpassword"} but you have to return in the form of tuple only.
  {:reply, return_value, new_state}

  Here, :reply is an atom
  return_value means what you have to return to the client as a response to his request
  new_state means the state after processing the client request.
  """
  def handle_call({:unlock, password}, _from, passwords) do
    if password in passwords do
      {:reply, :ok, passwords}

    else
      write_to_logfile passwords
      {:reply, {:error, "Wrong password"}, passwords}
    end
  end

  def handle_call({:reset, {old_password, new_password}}, _from, passwords) do
    if old_password in passwords do
      new_state = List.delete(passwords, old_password)
      {:reply, :ok, [new_password | new_state]}
      # here if old_password matches the password in the state variable passwords
      # we are updating the state to the new_password here.
    else
      write_to_logfile new_password
      {:reply, {:error, "wrongpassword"}, passwords}
    end
  end

  ## Log the passed text to the logged file
  defp write_to_logfile text do
    {:ok, pid} = PasswordLogger.start_link()
    PasswordLogger.log_incorrect pid,"wrongpassword #{text}"
  end

end
