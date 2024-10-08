resource "time_sleep" "wait_for_kubernetes" {

    depends_on = [
        data.aws_eks_cluster.sock-cluster
    ]

    create_duration = "20s"
}

resource "kubernetes_namespace" "nginx-namespace" {

  depends_on = [time_sleep.wait_for_kubernetes]
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [kubernetes_namespace.nginx-namespace, time_sleep.wait_for_kubernetes]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"

  namespace        = kubernetes_namespace.nginx-namespace.id
  create_namespace = true

  values = [
    file("values.yaml")
  ]

  set {
    name = "fullnameOverride"
    value = "load"
  }

  set {
    name = "controller.name"
    value = "nginx"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

 set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  } 
  
}