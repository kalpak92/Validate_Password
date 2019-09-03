# PasswordLock

Learning Elixiring by developing building a GenServer.
Here we assume only **single user** for our convenience.

1. **User** start the server and receives the `pid` of the server by initiating server state with some random password.
2. An `unlock` function to unlock the given password. 
   If the password given is same as the one given at the time of the execution, the server has to return `:ok` else it will written `{:error, "wrongpassword"}`
3. A `reset` function to reset the given password. If the old_password is correct , return `:ok` else `{:error, "wrongpassword"}`

Also tested the GenServer by writing a logger function that too using GenServer .

## Usage
```elixir
{:ok,pid } -> PasswordLock.start_link("hello")
```
### Unlock
```elixir
PasswordLock.unlock pid,"password_anything"
```
### reset 
```elixir
PasswordLock.reset pid,{"old_password","new_password"}
```
### test 
```elixir
mix test
```
