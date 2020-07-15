defprotocol BsvP2p.Command do
  @spec name(t) :: String.t()
  def name(command)

  @spec get_payload(t) :: binary
  def get_payload(command)
end
