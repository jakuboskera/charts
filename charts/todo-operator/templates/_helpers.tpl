{{/*
Return the proper todo-operator image name
*/}}
{{- define "todo-operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}
