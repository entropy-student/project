/*
Copyright (C) 2023-2026 QuantumNous

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

For commercial licensing, please contact support@quantumnous.com
*/
import { DEFAULT_LOGO, DEFAULT_SYSTEM_NAME } from './constants'

/** Keep administrator branding while replacing the upstream presentation defaults. */
export function displaySystemName(name?: string | null): string {
  return !name || /^new[\s-]?api$/i.test(name.trim())
    ? DEFAULT_SYSTEM_NAME
    : name
}

export function displaySystemLogo(logo?: string | null): string {
  return !logo || /^\/(?:logo\.(?:png|svg)|favicon\.ico)$/.test(logo)
    ? DEFAULT_LOGO
    : logo
}
