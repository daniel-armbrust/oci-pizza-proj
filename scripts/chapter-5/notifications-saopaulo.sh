#
# scripts/chapter-5/notifications-saopaulo.sh
#
# Copyright (C) 2005-2024 by Daniel Armbrust <darmbrust@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

#-----------------------------------------------#
# Brazil East (Sao Paulo) / sa-saopaulo-1 (GRU) #
#-----------------------------------------------#

# Source external files.
source functions.sh

# Globals
region="sa-saopaulo-1"
compartment_ocid="$COMPARTMENT_OCID"

fn_appl_name="fn-appl-ocipizza"

fn_user_register_name="fn-user-register"
topic_user_register_name="ocipizza-topic-user-registration"

fn_passwd_recovery_name="fn-passwd-recovery"
topic_password_recovery_name="ocipizza-topic-password-recovery"

fn_appl_ocid="$(get_fnappl_ocid "$region" "$fn_appl_name" "$compartment_ocid")"

# Topic - Registro de novo usuário.
#oci --region "$region" ons topic create \
#    --compartment-id "$compartment_ocid" \
#    --name "$topic_user_register_name" \
#    --description "Tópico: Processamento para Registro de um Novo Usuário."

topic_user_register_ocid="$(get_topic_ocid "$region" "$topic_user_register_name" "$compartment_ocid")"
fn_user_register_ocid="$(get_fn_ocid "$region" "$fn_user_register_name" "$compartment_ocid" "$fn_appl_ocid")"

# Subscription - Topic - Registro de novo usuário.
oci --region "$region" ons subscription create \
    --compartment-id "$compartment_ocid" \
    --topic-id "$topic_user_register_ocid" \
    --protocol "ORACLE_FUNCTIONS" \
    --subscription-endpoint "$fn_user_register_ocid" \
    --wait-for-state "ACTIVE"

# Topic - Redefinição de senha.
#oci --region "$region" ons topic create \
#    --compartment-id "$compartment_ocid" \
#    --name "$topic_password_recovery_name" \
#    --description "Tópico: Processamento para Recuperação de Senha."

topic_password_recovery_ocid="$(get_topic_ocid "$region" "$topic_password_recovery_name" "$compartment_ocid")"
fn_password_recovery_ocid="$(get_fn_ocid "$region" "$fn_passwd_recovery_name" "$compartment_ocid" "$fn_appl_ocid")"

# Subscription - Topic - Redefinição de senha.
oci --region "$region" ons subscription create \
    --compartment-id "$compartment_ocid" \
    --topic-id "$topic_password_recovery_ocid" \
    --protocol "ORACLE_FUNCTIONS" \
    --subscription-endpoint "$fn_password_recovery_ocid" \
    --wait-for-state "ACTIVE"

exit 0