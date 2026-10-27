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
import { memo } from 'react'

import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from '@/components/ui/card'
import { cn } from '@/lib/utils'

type SettingsCardProps = {
  title: string
  description?: string
  children: React.ReactNode
  className?: string
}

export const SettingsCard = memo(function SettingsCard({
  title,
  description,
  children,
  className,
}: SettingsCardProps) {
  return (
    <Card className={cn('gap-0 py-0', className)}>
      <CardHeader className='bg-muted/20 gap-2 border-b px-5 py-4 sm:px-6'>
        <CardTitle className='font-semibold'>{title}</CardTitle>
        {description && (
          <CardDescription className='max-w-prose leading-relaxed'>
            {description}
          </CardDescription>
        )}
      </CardHeader>
      <CardContent className='min-w-0 px-5 py-5 sm:px-6 sm:py-6'>
        {children}
      </CardContent>
    </Card>
  )
})
