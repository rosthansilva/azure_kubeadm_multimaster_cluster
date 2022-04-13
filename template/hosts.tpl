[kube_masters]
%{ for ip in kube_masters ~}
${ip}
%{ endfor ~}

[kube_workers]
%{ for ip in kube_workers ~}
${ip}
%{ endfor ~}

[ha-proxy]
%{ for ip in ha-proxy ~}
${ip}
%{ endfor ~}
