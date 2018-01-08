resource "kubernetes_namespace" "haystack-app-namespace" {
  metadata {
    name = "${var.k8s_app_namespace}"
  }
}

module "monitoring-addons" {
  source = "monitoring"
  kubectl_executable_name = "${var.kubectl_executable_name}"
  enabled = "${var.add_monitoring_addons}"
  k8s_cluster_name = "${var.k8s_cluster_name}"
}

module "logging-addongs" {
  source = "logging"
  kubectl_executable_name = "${var.kubectl_executable_name}"
  k8s_cluster_name = "${var.k8s_cluster_name}"
  enabled = "${var.add_logging_addons}"
  container_log_path = "${var.container_log_path}"
  es_nodes = "${var.logging_es_nodes}"
}

module "traefik-addon" {
  source = "traefik"
  kubectl_executable_name = "${var.kubectl_executable_name}"
  k8s_app_namespace = "${kubernetes_namespace.haystack-app-namespace.metadata.0.name}"
  haystack_domain_name = "${var.haystack_domain_name}"
  traefik_node_port = "${var.traefik_node_port}"
  k8s_cluster_name = "${var.k8s_cluster_name}"
}
