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
import { Link } from '@tanstack/react-router'
import { Activity } from 'lucide-react'
import { motion, useReducedMotion } from 'motion/react'
import { useId, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Area, AreaChart, CartesianGrid, XAxis, YAxis } from 'recharts'

import { EmptyState } from '@/components/empty-state'
import { ErrorState } from '@/components/error-state'
import { LoadingState } from '@/components/loading-state'
import { Button } from '@/components/ui/button'
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from '@/components/ui/chart'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { toIntlLocale } from '@/i18n/languages'
import { formatNumber, formatQuota } from '@/lib/format'

type OverviewUsageChartProps = {
  usage: number[]
  requests: number[]
  startTimestamp: number
  endTimestamp: number
  hasData: boolean
  loading: boolean
  error: boolean
  onRetry: () => void
}

export function OverviewUsageChart(props: OverviewUsageChartProps) {
  const { t, i18n } = useTranslation()
  const locale = toIntlLocale(i18n.resolvedLanguage || i18n.language)
  const reduceMotion = useReducedMotion()
  const gradientId = `overview-usage-${useId().replaceAll(':', '')}`
  const [metric, setMetric] = useState('usage')
  const data = useMemo(
    () =>
      props.usage.map((usage, index) => {
        const timestamp =
          props.startTimestamp +
          ((props.endTimestamp - props.startTimestamp) * index) /
            props.usage.length
        return {
          time: new Date(timestamp * 1000).toLocaleTimeString(locale, {
            hour: '2-digit',
            minute: '2-digit',
          }),
          usage,
          requests: props.requests[index] ?? 0,
        }
      }),
    [
      locale,
      props.endTimestamp,
      props.requests,
      props.startTimestamp,
      props.usage,
    ]
  )
  const metricLabel = metric === 'usage' ? t('Usage') : t('Requests')

  let content
  if (props.loading) {
    content = <LoadingState className='spw-overview-chart-state' />
  } else if (props.error) {
    content = (
      <ErrorState
        className='spw-overview-chart-state'
        onRetry={props.onRetry}
      />
    )
  } else if (!props.hasData) {
    content = (
      <EmptyState
        icon={Activity}
        title={t('No recent usage')}
        description={t('Monitor balance, usage, and request volume')}
        className='spw-overview-chart-state'
        action={
          <Button
            variant='outline'
            size='sm'
            render={<Link to='/usage-logs' />}
          >
            {t('Usage Logs')}
          </Button>
        }
      />
    )
  } else {
    content = (
      <motion.div
        key={metric}
        initial={reduceMotion ? false : { x: 8 }}
        animate={{ x: 0 }}
        transition={{ duration: 0.22, ease: 'easeOut' }}
      >
        <ChartContainer
          className='spw-overview-chart'
          config={{
            usage: { label: t('Usage'), color: 'var(--spw-focus)' },
            requests: { label: t('Requests'), color: 'var(--spw-focus)' },
          }}
          role='img'
          aria-label={`${metricLabel}, ${t('Last 24 hours')}`}
        >
          <AreaChart
            data={data}
            margin={{ top: 10, right: 6, left: 0, bottom: 0 }}
            accessibilityLayer
          >
            <defs>
              <linearGradient id={gradientId} x1='0' y1='0' x2='0' y2='1'>
                <stop
                  offset='0%'
                  stopColor='var(--spw-focus)'
                  stopOpacity={0.2}
                />
                <stop
                  offset='100%'
                  stopColor='var(--spw-focus)'
                  stopOpacity={0.015}
                />
              </linearGradient>
            </defs>
            <CartesianGrid
              vertical={false}
              stroke='var(--border)'
              strokeOpacity={0.6}
            />
            <XAxis
              dataKey='time'
              tickLine={false}
              axisLine={false}
              minTickGap={36}
              tickMargin={12}
            />
            <YAxis
              domain={['auto', 'auto']}
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              width={72}
              tickFormatter={(value: number) =>
                metric === 'usage'
                  ? formatQuota(value)
                  : formatNumber(value, locale)
              }
            />
            <ChartTooltip
              content={
                <ChartTooltipContent
                  formatter={(value) =>
                    metric === 'usage'
                      ? formatQuota(Number(value))
                      : formatNumber(Number(value), locale)
                  }
                />
              }
            />
            <Area
              dataKey={metric}
              type='monotone'
              stroke='var(--spw-focus)'
              strokeWidth={2}
              fill={`url(#${gradientId})`}
              isAnimationActive={false}
            />
          </AreaChart>
        </ChartContainer>
      </motion.div>
    )
  }

  return (
    <Tabs
      value={metric}
      onValueChange={(value) => setMetric(String(value))}
      className='spw-overview-trend'
    >
      <div className='spw-overview-trend-header'>
        <div>
          <h3>{t('Usage at a glance')}</h3>
          <span>{t('Last 24 hours')}</span>
        </div>
        <TabsList aria-label={t('Usage at a glance')}>
          {(['usage', 'requests'] as const).map((value) => (
            <TabsTrigger key={value} value={value}>
              {metric === value && (
                <motion.span
                  className='spw-overview-metric-indicator'
                  layoutId={`${gradientId}-indicator`}
                  transition={
                    reduceMotion
                      ? { duration: 0 }
                      : { type: 'spring', stiffness: 450, damping: 32 }
                  }
                  aria-hidden='true'
                />
              )}
              <span className='relative'>
                {value === 'usage' ? t('Usage') : t('Requests')}
              </span>
            </TabsTrigger>
          ))}
        </TabsList>
      </div>
      {(['usage', 'requests'] as const).map((value) => (
        <TabsContent key={value} value={value} aria-busy={props.loading}>
          {value === metric ? content : null}
        </TabsContent>
      ))}
    </Tabs>
  )
}
