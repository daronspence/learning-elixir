defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [reaquest_line | header_lines] = String.split(top, "\n")

    [method, path, _version] = String.split(reaquest_line, " ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers,
    }
  end

  defp parse_params("application/x-www-form-urlencoded", params) do
    params
    |> String.trim()
    |> URI.decode_query()
  end

  defp parse_params(_, _), do: %{}

  defp parse_headers([head | tail], %{} = headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], %{} = headers), do: headers

end
