defmodule PasswordLogger do
  use GenServer

  # -------------#
  # Client - API #
  # -------------#

  @moduledoc """
  Documentation for Password_logger.
  loggs the password
  """
  @doc """
  Initiate with the given file_logger with file name  .
  """
  def start_link() do
    GenServer.start_link(__MODULE__, "/tmp/password_logs", [])
  end

  @doc """
  Client function to make logging request.
  """

  def log_incorrect(pid, logtext) do
    GenServer.cast(pid,{:log,logtext})  # Asynchronous requests
  end


  ##---------- ##
  #Server - API #
  ##-----------##

  def init(logfile) do
    {:ok, logfile} # initated the server state with the logfile
  end

  def handle_cast({:log, logtext}, file_name) do
    {:ok, file} = File.open file_name, [:append]  # opening in append mode so it can log in the same file.
    File.chmod!(file_name,0o755)                  # change the permission of the file to get write permission
    IO.binwrite file, logtext <> "\n"
    File.close file
    {:noreply,file_name}
  end
end
