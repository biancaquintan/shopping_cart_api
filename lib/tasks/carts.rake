# frozen_string_literal: true

# lib/tasks/carts.rake
namespace :carts do
  desc 'Executa o job de marcação e remoção de carrinhos abandonados'
  task mark_and_cleanup_abandoned: :environment do
    puts 'Iniciando MarkCartAsAbandonedJob...'
    MarkCartAsAbandonedJob.new.perform
    puts 'Job finalizado com sucesso.'
  end
end
