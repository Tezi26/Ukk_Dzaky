<x-filament-panels::page>
    <style>
        .rpt { width: 100%; border-collapse: collapse; }
        .rpt th, .rpt td { border: 1px solid #999; padding: 6px; }
        @media print {
            .fi-sidebar, .fi-topbar, .no-print { display: none !important; }
        }
    </style>

    <x-filament::button class="no-print" icon="heroicon-o-printer"
        onclick="window.print()">Cetak Laporan</x-filament::button>

    <table class="rpt">
        <tr>
            <th>Peminjam</th>
            <th>Alat</th>
            <th>Jumlah</th>
            <th>Jatuh Tempo</th>
            <th>Status</th>
        </tr>
        @foreach ($loans as $loan)
            <tr>
                <td>{{ $loan->user->name }}</td>
                <td>{{ $loan->tool->name }}</td>
                <td>{{ $loan->quantity }}</td>
                <td>{{ $loan->due_date->format('d/m/Y') }}</td>
                <td>{{ $loan->status }}</td>
            </tr>
        @endforeach
    </table>
</x-filament-panels::page>