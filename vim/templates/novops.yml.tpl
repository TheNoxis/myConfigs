# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: [:VIM_EVAL:]$FULLNAME[:END_EVAL:]
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] [:VIM_EVAL:]$COPYRIGHT[:END_EVAL:]
# Describle:
#

config:
  hashivault:
environments:
  prod:
    variables:
      - name: VARIABLE_VOULUE
        value:
          hvault_kv2:
            mount: "kv_engine_name"
            path: "chemin/vers/le/secret"
            key: "password"
