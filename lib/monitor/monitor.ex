defmodule Worldping.Monitor do
  import Worldping

  @doc """
  Create a JSON specification for an http monitor based on the given parameters
  """
  def http(host \\ "www.raintank.io", port \\ "80", path \\ "/", timeout \\ "5", method \\ "GET", expectRegex \\ "", endpoint_id \\ -1, collector_ids \\ [1, 2, 3, 4], collector_tags \\ [], enabled \\ true, frequency \\ 120, health_steps \\ 3, health_collectors \\ 3, health_notification_enabled \\ true, health_notification_email \\ "")
  def http(host, port, path, timeout, method, expectRegex, collector_ids, collector_tags, enabled, frequency, health_steps, health_collectors, health_notification_enabled, health_notification_email) do
    settings = [
      %{variable: "host", value: host},
      %{variable: "port", value: port},
      %{variable: "path", value: path},
      %{variable: "timeout", value: timeout},
      %{variable: "method", value: method},
      %{variable: "expectRegex", value: expectRegex}
    ]
    health_settings = health_settings_spec(health_steps, health_collectors, health_notification_enabled, health_notification_email)
    monitor_spec(1, settings, endpoint_id, collector_ids, collector_tags, enabled, frequency, health_settings)
  end

  @doc """
  Create a JSON specification for an https monitor based on the given parameters
  """
  def https(host \\ "www.raintank.io", port \\ "443", path \\ "/", timeout \\ "5", method \\ "GET", expectRegex \\ "", validateCert \\ true, endpoint_id \\ -1, collector_ids \\ [1, 2, 3, 4], collector_tags \\ [], enabled \\ true, frequency \\ 120, health_steps \\ 3, health_collectors \\ 3, health_notification_enabled \\ true, health_notification_email \\ "")
  def https(host, port, path, timeout, method, expectRegex, validateCert, collector_ids, collector_tags, enabled, frequency, health_steps, health_collectors, health_notification_enabled, health_notification_email) do
    settings = [
      %{variable: "host", value: host},
      %{variable: "port", value: port},
      %{variable: "path", value: path},
      %{variable: "timeout", value: timeout},
      %{variable: "method", value: method},
      %{variable: "expectRegex", value: expectRegex},
      %{variable: "validateCert", value: validateCert}
    ]
    health_settings = health_settings_spec(health_steps, health_collectors, health_notification_enabled, health_notification_email)
    monitor_spec(2, settings, endpoint_id, collector_ids, collector_tags, enabled, frequency, health_settings)
  end

  @doc """
  Create a JSON specification for a ping monitor based on the given parameters
  """
  def ping(hostname \\ "www.raintank.io", timeout \\ "5", endpoint_id \\ -1, collector_ids \\ [1, 2, 3, 4], collector_tags \\ [], enabled \\ true, frequency \\ 120, health_steps \\ 3, health_collectors \\ 3, health_notification_enabled \\ true, health_notification_email \\ "")
  def ping(hostname, timeout, collector_ids, collector_tags, enabled, frequency, health_steps, health_collectors, health_notification_enabled, health_notification_email) do
    settings = [
      %{variable: "hostname", value: hostname},
      %{variable: "timeout", value: timeout}
    ]
    health_settings = health_settings_spec(health_steps, health_collectors, health_notification_enabled, health_notification_email)
    monitor_spec(3, settings, endpoint_id, collector_ids, collector_tags, enabled, frequency, health_settings)
  end

  @doc """
  Create a JSON specification for a DNS monitor based on the given parameters
  """
  def dns(name \\ "raintank.io", type \\ "A", protocol \\ "udp", timeout \\ "5", endpoint_id \\ -1, collector_ids \\ [1, 2, 3, 4], collector_tags \\ [], enabled \\ true, frequency \\ 120, health_steps \\ 3, health_collectors \\ 3, health_notification_enabled \\ true, health_notification_email \\ "")
  def dns(name, type, protocol, timeout, collector_ids, collector_tags, enabled, frequency, health_steps, health_collectors, health_notification_enabled, health_notification_email) do
    settings = [
      %{variable: "name", value: name},
      %{variable: "type", value: type},
      %{variable: "protocol", value: protocol},
      %{variable: "timeout", value: timeout}
    ]
    health_settings = health_settings_spec(health_steps, health_collectors, health_notification_enabled, health_notification_email)
    monitor_spec(4, settings, endpoint_id, collector_ids, collector_tags, enabled, frequency, health_settings)
  end

  defp health_settings_spec(steps, collectors, notification_enabled, notification_email) do
    %{
      steps: steps,
      num_collectors: collectors,
      notifications: %{
        enabled: notification_enabled,
        addresses: notification_email
      }
    }
  end

  defp monitor_spec(monitor_type_id, settings, endpoint_id, collector_ids, collector_tags, enabled, frequency, health_settings) do
    %{
      MonitorTypeId: monitor_type_id,
      settings: settings,
      EndpointId: endpoint_id,
      collector_ids: collector_ids,
      collector_tags: collector_tags,
      enabled: enabled,
      frequency: frequency,
      health_settings: health_settings
    }
  end
end
