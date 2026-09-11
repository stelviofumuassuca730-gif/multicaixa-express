import { NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function POST(request: Request) {
  try {
    const body = await request.json()

    const { data, error } = await supabase
      .from('transactions')
      .insert([
        {
          type: body.type,
          recipient: body.recipient,
          holder_name: body.holderName,
          amount: body.amount,
          fee: body.fee,
          tax: body.tax,
          date: body.date,
          reference: body.reference,
          status: body.status,
          card_last4: body.cardLast4,
          completed_at: body.completedAt,
        },
      ])
      .select()
      .single()

    if (error) {
      console.error('Erro ao guardar transação:', error)

      return NextResponse.json(
        { error: error.message },
        { status: 500 }
      )
    }

    return NextResponse.json(data, { status: 201 })
  } catch (error) {
    console.error('Erro na API:', error)

    return NextResponse.json(
      { error: 'Erro ao processar a transação' },
      { status: 500 }
    )
  }
}