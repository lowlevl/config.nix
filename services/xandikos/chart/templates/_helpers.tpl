{{/*
Create image name and tag used by the deployment.
*/}}
{{- define "xandikos.image" -}}
{{- $registry := .Values.image.registry -}}
{{- $name := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
  {{- printf "%s/%s:%s" $registry $name $tag -}}
{{- else -}}
  {{- printf "%s:%s" $name $tag -}}
{{- end -}}
{{- end -}}


{{/*
Create the PVC name
*/}}
{{- define "xandikos.claimName" -}}
{{- if and .Values.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s-pvc" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
