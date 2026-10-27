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
import { Activity, BarChart3, WalletCards } from 'lucide-react'
import { useTranslation } from 'react-i18next'

import { IconBadge, type IconBadgeTone } from '@/components/ui/icon-badge'
import { Skeleton } from '@/components/ui/skeleton'
import { formatQuota } from '@/lib/format'
import { cn } from '@/lib/utils'

import type { UserWalletData } from '../types'

interface WalletStatsCardProps {
  user: UserWalletData | null
  loading?: boolean
}

export function WalletStatsCard(props: WalletStatsCardProps) {
  const { t } = useTranslation()
  if (props.loading) {
    return (
      <div
        role='status'
        aria-label={t('Loading...')}
        className='spw-wallet-summary grid grid-cols-2'
      >
        {['balance', 'usage', 'requests'].map((key, index) => (
          <div
            key={key}
            className={cn(
              'min-w-0 p-5',
              index === 0 ? 'spw-wallet-balance col-span-2' : 'spw-wallet-stat'
            )}
          >
            <Skeleton className='h-3.5 w-full' />
            <Skeleton className='mt-2 h-6 w-full sm:h-7' />
            <Skeleton className='mt-1.5 hidden h-3.5 w-24 md:block' />
          </div>
        ))}
      </div>
    )
  }

  const stats: {
    label: string
    value: string
    description: string
    icon: typeof WalletCards
    tone: IconBadgeTone
  }[] = [
    {
      label: t('Current Balance'),
      value: formatQuota(props.user?.quota ?? 0),
      description: t('Remaining quota'),
      icon: WalletCards,
      tone: 'success',
    },
    {
      label: t('Total Usage'),
      value: formatQuota(props.user?.used_quota ?? 0),
      description: t('Total consumed quota'),
      icon: BarChart3,
      tone: 'info',
    },
    {
      label: t('API Requests'),
      value: (props.user?.request_count ?? 0).toLocaleString(),
      description: t('Total requests made'),
      icon: Activity,
      tone: 'chart-4',
    },
  ]

  return (
    <div className='spw-wallet-summary grid grid-cols-2'>
      {stats.map((item, index) => (
        <div
          key={item.label}
          className={cn(
            'min-w-0 p-5',
            index === 0 ? 'spw-wallet-balance col-span-2' : 'spw-wallet-stat'
          )}
        >
          <div className='flex items-center gap-1.5 sm:gap-2.5'>
            <IconBadge tone={item.tone} size='stat'>
              <item.icon />
            </IconBadge>
            <div className='spw-wallet-stat-label text-xs font-medium'>
              {item.label}
            </div>
          </div>

          <div
            className={cn(
              'spw-wallet-stat-value mt-5 font-semibold break-all tabular-nums',
              index === 0 ? 'text-4xl sm:text-5xl' : 'text-xl sm:text-2xl'
            )}
          >
            {item.value}
          </div>
          <div className='spw-wallet-stat-description mt-3 text-xs'>
            {item.description}
          </div>
        </div>
      ))}
    </div>
  )
}
