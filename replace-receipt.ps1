$path = (Resolve-Path "app\page.tsx").Path
$text = [System.IO.File]::ReadAllText($path)
$start = $text.IndexOf("async function buildReceiptPdf")
$end = $text.IndexOf("async function shareReceipt", $start)
if ($start -lt 0 -or $end -lt 0) {
    Write-Host "ERRO: não encontrei buildReceiptPdf ou shareReceipt"
    exit
}
$newFunction = @'
async function buildReceiptPdf(op:Op){
  const pdf=new jsPDF({
    orientation:'portrait',
    unit:'mm',
    format:'a4'
  });
  try{
    const response=await fetch('/assets/bpc-logo-reference.png');
    const blob=await response.blob();
    const data=await new Promise<string>(resolve=>{
      const reader=new FileReader();
      reader.onload=()=>resolve(String(reader.result));
      reader.readAsDataURL(blob);
    });
    pdf.addImage(data,'PNG',166,10,24,12);
  }catch{}
  pdf.setFont('helvetica','normal');
  pdf.setFontSize(6);
  pdf.setTextColor(0,0,0);
  pdf.text('Comprovativo digital',12,15);
  pdf.text('MULTICAIXA Express',12,19);
  pdf.text(`Data: ${formatReceiptDate(op.completedAt||op.date)}`,12,23);
  pdf.setFontSize(16);
  pdf.setTextColor(200,0,0);
  pdf.text('Comprovativo Digital',105,32,{align:'center'});
  pdf.setDrawColor(225,225,225);
  pdf.setLineWidth(0.35);
  pdf.line(12,39,198,39);
  pdf.setFont('helvetica','normal');
  pdf.setFontSize(8);
  pdf.setTextColor(0,0,0);
  pdf.text(
    'Detalhe da operação realizada através',
    105,
    48,
    {align:'center'}
  );
  pdf.text(
    'do canal MULTICAIXA Express.',
    105,
    53,
    {align:'center'}
  );
  const rows=[
    ['Data - Hora',formatReceiptDate(op.completedAt||op.date)],
    ['Operação',op.type],
    ['Destinatário',op.holderName||op.recipient],
    ['IBAN',formatIban(op.account)],
    ['Montante',op.amount],
    ['Comissão','-'],
    ['Imposto','-'],
    ['Total',op.amount],
    ['Transacção',op.reference]
  ];
  let y=80;
  pdf.setDrawColor(210,0,0);
  pdf.setLineWidth(0.45);
  pdf.line(72,75,72,163);
  rows.forEach(([label,value])=>{
    pdf.setFont('helvetica','bold');
    pdf.setFontSize(8);
    pdf.text(label,68,y,{align:'right'});
    pdf.setFont('helvetica','normal');
    pdf.text(String(value),76,y);
    y+=9;
  });
  pdf.setFont('helvetica','normal');
  pdf.setFontSize(8);
  pdf.setTextColor(0,0,0);
  pdf.text(
    'Comprovativo da operação realizada através do MULTICAIXA Express.',
    105,
    224,
    {align:'center'}
  );
  pdf.setFont('helvetica','bold');
  pdf.text(
    'MULTICAIXA Express',
    105,
    231,
    {align:'center'}
  );
  pdf.setFillColor(218,218,199);
  pdf.rect(12,237,186,20,'F');
  pdf.setFont('helvetica','normal');
  pdf.setFontSize(6);
  pdf.text(
    'Para informações relacionadas com esta operação, consulte',
    105,
    244,
    {align:'center'}
  );
  pdf.text(
    'os canais de suporte disponibilizados na aplicação.',
    105,
    249,
    {align:'center'}
  );
  pdf.setDrawColor(200,200,200);
  pdf.setLineWidth(0.25);
  pdf.line(12,262,198,262);
  pdf.setFontSize(6);
  pdf.setTextColor(120,120,120);
  pdf.text(
    `Referência da operação: ${op.reference}`,
    105,
    268,
    {align:'center'}
  );
  return pdf.output('blob');
}
'@
$text = $text.Substring(0,$start) + $newFunction + $text.Substring($end)
[System.IO.File]::WriteAllText(
  $path,
  $text,
  [System.Text.UTF8Encoding]::new($false)
)
Write-Host "buildReceiptPdf substituída com sucesso."
